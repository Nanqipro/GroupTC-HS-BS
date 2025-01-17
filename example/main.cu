#include <string>

#include "main.h"

int main(int argc, char** argv) {
    std::string config_file = "config.ini";
    if (argc > 1) {
        config_file = argv[1];
    }

    INIReader config(config_file);
    if (config.ParseError() < 0) {
        spdlog::info("Can't load {}", config_file);
        return 1;
    }

    // comm config
    std::string input_file = config.Get("comm", "dataset", "UNKNOWN");
    std::string log_level_str = config.Get("comm", "log_level", "info");
    spdlog::level::level_enum log_level = switch_log_level(log_level_str);
    spdlog::set_level(log_level);

    int device = config.GetInteger("comm", "device", 0);
    HRR(cudaSetDevice(device));
    spdlog::info("Use device {}", device);

    // read dataset and preprocessing dataset
    CPUGraph cpu_graph(input_file);

    if (cpu_graph.edge_count > constant_comm::kMaxGraphEdgeCount) {
        spdlog::info("Input graph is too large! Exit ...");
        return 1;
    }

    // GPUGraph dcsr(cpu_graph);

    {
        Csr2DcsrDataTransfer cddt(input_file, &cpu_graph);
        cddt.transfer();
        GPUGraph& dcsr = cddt.d_graph;
        tc::approach::Polak::start_up(config, dcsr, argc, argv);
        tc::approach::TriCore::start_up(config, dcsr, argc, argv);
        tc::approach::HINDEX::start_up(config, dcsr, argc, argv);
        tc::approach::Green::start_up(config, dcsr, argc, argv);
        tc::approach::Hu::start_up(config, dcsr, argc, argv);
        tc::approach::TC_Check::start_up(config, dcsr, argc, argv);
        tc::approach::Fox::start_up(config, dcsr, argc, argv);
    }

    {
        Csr2RidDcsrDataTransfer crdt(input_file, &cpu_graph);
        crdt.transfer();
        GPUGraph& riddcsr = crdt.d_graph;
        tc::approach::Bisson::start_up(config, riddcsr, argc, argv);
        tc::approach::GroupTC::start_up(config, riddcsr, argc, argv);
        tc::approach::GroupTC_OPT::start_up(config, riddcsr, argc, argv);
    }

    {
        Csr2TrustDcsrDataTransfer ctdt(input_file, &cpu_graph);
        ctdt.transfer();
        GPUGraph& trustdcsr = ctdt.d_graph;
        tc::approach::GroupTC_HASH::start_up(config, trustdcsr, argc, argv);
        tc::approach::TRUST::start_up(config, trustdcsr, argc, argv);
    }

    return 0;
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
