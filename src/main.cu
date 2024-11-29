#include <unistd.h>
#include <string>
#include "main.h"

// 主线函数
int main(int argc, char** argv) {
    std::string program_dir = get_program_dir();
    std::string config_file = program_dir + "/../config/config.ini";
    std::string config_dataset = "";

    // 存储命令行参数
    std::vector<std::string> args(argv, argv + argc);

    // 遍历命令行参数
    for (int i = 1; i < argc; ++i) {  // 从1开始，跳过程序名称
        std::string arg = args[i];
        if (arg.find("-config=") != std::string::npos) {
            config_file = arg.substr(8);
            spdlog::info("Config file is {}", config_file);
        }
        if (arg.find("-dataset=") != std::string::npos) {
            config_dataset = arg.substr(9);
            spdlog::info("Config_dataset file is {}", config_dataset);
        }
    }

    INIReader config(config_file);
    if (config.ParseError() < 0) {
        spdlog::info("Can't load {}", config_file);
        return 1;
    }

    // set comm config
    std::string dataset_file_path = config.Get("comm", "dataset_file_path", "UNKNOWN");
    std::string log_file_path = config.Get("comm", "log_file_path", "UNKNOWN");
    std::string str_datasets_1 = config.Get("comm", "datasets_1", "");
    std::string str_datasets_2 = config.Get("comm", "datasets_2", "");
    std::string log_level_str = config.Get("comm", "log_level", "info");
    spdlog::level::level_enum log_level = switch_log_level(log_level_str);
    spdlog::set_level(log_level);

    config_comm::cPreprocessingIterations = config.GetInteger("comm", "preprocessing_iterations", 1);

    int device = config.GetInteger("comm", "device", 0);
    HRR(cudaSetDevice(device));
    spdlog::info("Use device {}", device);

    // init loggers
    init_loggers(log_file_path);

    std::vector<std::string> datasets_1 = get_datasets(str_datasets_1);
    std::vector<std::string> datasets_2 = get_datasets(str_datasets_2);
    std::vector<std::string> datasets = merge_vectors(datasets_1, datasets_2);

    for (auto dataset : datasets) {
        std::string input_file = dataset_file_path + dataset;
        if (config_dataset != "" && dataset != config_dataset) {
            continue;
        }

        // read dataset
        CPUGraph cpu_graph(input_file);

        if (cpu_graph.edge_count > constant_comm::kMaxGraphEdgeCount) {
            spdlog::info("Input graph is too large! Process next graph ...");
            continue;
        }

        // preprocess datasets and run algorithms
        {
            Csr2DcsrDataTransfer cddt(input_file, &cpu_graph);
            cddt.transfer();
            GPUGraph& dcsr = cddt.d_graph;

            tc::approach::Polak::start_up(config, dcsr, argc, argv);
            tc::approach::TriCore::start_up(config, dcsr, argc, argv);
            tc::approach::H_INDEX::start_up(config, dcsr, argc, argv);
            tc::approach::Green::start_up(config, dcsr, argc, argv);
            tc::approach::Hu::start_up(config, dcsr, argc, argv);
            // tc::approach::TC_Check::start_up(config, dcsr, argc, argv);
            // tc::approach::GroupTC::start_up(config, dcsr, argc, argv);
            // tc::approach::GroupTC_OPT::start_up(config, dcsr, argc, argv);
            tc::approach::Fox::start_up(config, dcsr, argc, argv);
        }

        {
            Csr2RidDcsrDataTransfer crdt(input_file, &cpu_graph);
            crdt.transfer();
            GPUGraph& riddcsr = crdt.d_graph;

            tc::approach::Bisson::start_up(config, riddcsr, argc, argv);
            tc::approach::GroupTC::start_up(config, riddcsr, argc, argv);
            tc::approach::TC_Check::start_up(config, riddcsr, argc, argv);
            tc::approach::GroupTC_OPT::start_up(config, riddcsr, argc, argv);
        }

        {
            Csr2TrustDcsrDataTransfer ctdt(input_file, &cpu_graph);
            ctdt.transfer();
            GPUGraph& trustdcsr = ctdt.d_graph;

            tc::approach::GroupTC_HASH::start_up(config, trustdcsr, argc, argv);
            tc::approach::TRUST::start_up(config, trustdcsr, argc, argv);
        }

        flush_loggers();
    }

    spdlog::info("All input graphs have been processed, the program ends.");

    return 0;
}

// 支线函数
int main1(int argc, char** argv) {
    std::string config_file = "../config/config.ini";
    if (argc > 1) {
        config_file = argv[1];
    }

    INIReader config(config_file);
    if (config.ParseError() < 0) {
        spdlog::error("Can't load {}", config_file);
        return 1;
    }
    // comm config
    std::string input_file = config.Get("comm", "dataset", "UNKNOWN");
    std::string log_level_str = config.Get("comm", "log_level", "info");
    int device = config.GetInteger("comm", "device", 0);
    HRR(cudaSetDevice(device));

    size_t free_byte, total_byte;
    // HRR(cudaMemGetInfo(&free_byte, &total_byte));
    // spdlog::info("{:.2f}", float(total_byte) / MEMORY_G);
    // spdlog::info("{:.2f}", float(free_byte) / MEMORY_G);
    // spdlog::info("{:.2f}", float(total_byte - free_byte) / MEMORY_G);

    spdlog::level::level_enum log_level = switch_log_level(log_level_str);
    spdlog::set_level(log_level);
    CPUGraph cpu_graph(input_file);
    // GPUGraph gpu_graph(cpu_graph);

    HRR(cudaMemGetInfo(&free_byte, &total_byte));
    spdlog::info("{:.2f}", float(total_byte) / MEMORY_G);
    spdlog::info("{:.2f}", float(free_byte) / MEMORY_G);
    spdlog::info("{:.2f}", float(total_byte - free_byte) / MEMORY_G);

    index_t* arr;
    index_t* key_arr;
    uint edge_count = cpu_graph.edge_count;
    size_t max_sort_len = 1e9 * 1.3;
    spdlog::info("{0} {1} {2}", edge_count, max_sort_len, (size_t)sizeof(index_t) * max_sort_len);
    HRR(cudaMalloc(&arr, (size_t)sizeof(index_t) * max_sort_len));
    HRR(cudaMalloc(&key_arr, (size_t)sizeof(index_t) * max_sort_len));
    // HRR(cudaMemcpy(arr, cpu_graph.adj_list, sizeof(index_t) * 5e8, cudaMemcpyHostToDevice));

    HRR(cudaMemGetInfo(&free_byte, &total_byte));
    spdlog::info("{:.2f}", float(total_byte - free_byte) / MEMORY_G);

    thrust::device_ptr<index_t> sort_ptr((index_t*)arr);
    thrust::device_ptr<index_t> key_ptr((index_t*)key_arr);
    // thrust::sort_by_key(key_ptr, key_ptr + max_sort_len, sort_ptr);
    thrust::sort(sort_ptr, sort_ptr + max_sort_len);

    // // spdlog::info("sort big arr start.");
    // // cuda_graph_comm::sort_big_arr(arr, edge_count);
    // // spdlog::info("sort big arr end.");

    // HRR(cudaFree(arr));
    return 0;
}

std::string get_program_dir() {
    char buffer[1024];
    ssize_t len = readlink("/proc/self/exe", buffer, sizeof(buffer) - 1);
    if (len != -1) {
        buffer[len] = '\0';
        std::string fullPath(buffer);
        std::string::size_type pos = fullPath.find_last_of("/");
        std::string program_directory = fullPath.substr(0, pos);
        return program_directory;
    }
    return "";
}

std::vector<std::string> get_datasets(const std::string& str, const std::string& delimiter) {
    std::vector<std::string> datasets;
    size_t pos = 0;
    std::string dataset;
    std::string str_copy = str;
    while ((pos = str_copy.find(delimiter)) != std::string::npos) {
        dataset = str_copy.substr(0, pos);
        dataset.erase(std::remove(dataset.begin(), dataset.end(), ' '), dataset.end());
        if (!dataset.empty()) {
            datasets.push_back(dataset);
        }
        str_copy.erase(0, pos + delimiter.length());
    }
    str_copy.erase(std::remove(str_copy.begin(), str_copy.end(), ' '), str_copy.end());
    if (!str_copy.empty()) {
        datasets.push_back(str_copy);
    }
    return datasets;
}

std::vector<std::string> merge_vectors(const std::vector<std::string>& vec1, const std::vector<std::string>& vec2) {
    std::vector<std::string> merged_vec;

    merged_vec.insert(merged_vec.end(), vec1.begin(), vec1.end());
    merged_vec.insert(merged_vec.end(), vec2.begin(), vec2.end());

    return merged_vec;
}

void init_loggers(std::string log_file_path) {
    try {
        init_file_logger("csr2dcsr_file_logger", log_file_path + "csr2dcsr/time_output.txt", spdlog::level::info);
        init_file_logger("csr2rid_dcsr_file_logger", log_file_path + "csr2rid_dcsr/time_output.txt", spdlog::level::info);
        init_file_logger("csr2trust_dcsr_file_logger", log_file_path + "csr2trust_dcsr/time_output.txt", spdlog::level::info);

        init_file_logger("Fox_preprocessing_file_logger", log_file_path + "Fox/preprocessing_time_output.txt", spdlog::level::info);
        init_file_logger("Hu_preprocessing_file_logger", log_file_path + "Hu/preprocessing_time_output.txt", spdlog::level::info);

        init_file_logger("Bisson_file_logger", log_file_path + "Bisson/time_output.txt", spdlog::level::info);
        init_file_logger("Fox_file_logger", log_file_path + "Fox/time_output.txt", spdlog::level::info);
        init_file_logger("Green_file_logger", log_file_path + "Green/time_output.txt", spdlog::level::info);
        init_file_logger("GroupTC_file_logger", log_file_path + "GroupTC/time_output.txt", spdlog::level::info);
        init_file_logger("GroupTC-HASH_file_logger", log_file_path + "GroupTC-HASH/time_output.txt", spdlog::level::info);
        init_file_logger("GroupTC-OPT_file_logger", log_file_path + "GroupTC-OPT/time_output.txt", spdlog::level::info);
        init_file_logger("H-INDEX_file_logger", log_file_path + "H-INDEX/time_output.txt", spdlog::level::info);
        init_file_logger("Hu_file_logger", log_file_path + "Hu/time_output.txt", spdlog::level::info);
        init_file_logger("Polak_file_logger", log_file_path + "Polak/time_output.txt", spdlog::level::info);
        init_file_logger("TriCore_file_logger", log_file_path + "TriCore/time_output.txt", spdlog::level::info);
        init_file_logger("TRUST_file_logger", log_file_path + "TRUST/time_output.txt", spdlog::level::info);

    } catch (const spdlog::spdlog_ex& ex) {
        spdlog::error("Log init failed: {}", ex.what());
    }
}

void init_file_logger(std::string logger_name, std::string file, spdlog::level::level_enum log_level) {
    std::shared_ptr<spdlog::logger> logger = spdlog::basic_logger_mt(logger_name, file);
    logger->set_level(log_level);
}

void flush_loggers() {
    spdlog::get("csr2dcsr_file_logger")->flush();
    spdlog::get("csr2rid_dcsr_file_logger")->flush();
    spdlog::get("csr2trust_dcsr_file_logger")->flush();

    spdlog::get("Fox_preprocessing_file_logger")->flush();
    spdlog::get("Hu_preprocessing_file_logger")->flush();

    spdlog::get("Bisson_file_logger")->flush();
    spdlog::get("Fox_file_logger")->flush();
    spdlog::get("Green_file_logger")->flush();
    spdlog::get("GroupTC_file_logger")->flush();
    spdlog::get("GroupTC-HASH_file_logger")->flush();
    spdlog::get("GroupTC-OPT_file_logger")->flush();
    spdlog::get("H-INDEX_file_logger")->flush();
    spdlog::get("Hu_file_logger")->flush();
    spdlog::get("Polak_file_logger")->flush();
    spdlog::get("TriCore_file_logger")->flush();
    spdlog::get("TRUST_file_logger")->flush();
}

spdlog::level::level_enum switch_log_level(std::string log_level_str) {
    if (log_level_str == "trace") {
        return spdlog::level::trace;
    } else if (log_level_str == "debug") {
        return spdlog::level::debug;
    } else if (log_level_str == "info") {
        return spdlog::level::info;
    } else if (log_level_str == "warn") {
        return spdlog::level::warn;
    } else if (log_level_str == "err") {
        return spdlog::level::err;
    } else if (log_level_str == "critical") {
        return spdlog::level::critical;
    } else if (log_level_str == "off") {
        return spdlog::level::off;
    } else {
        return spdlog::level::info;
    }
}
