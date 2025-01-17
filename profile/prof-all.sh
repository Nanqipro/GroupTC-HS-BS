#!/bin/bash

# 定义基础变量
CUDA_PATH="/usr/local/cuda-11.4/bin/nvprof"
LOG_DIR="/home/LiJB/cuda_project/TC-compare-V100/log/D01-10-profile"
EXEC_PATH="/home/LiJB/cuda_project/TC-compare-V100/build/main"
METRICS="achieved_occupancy,branch_efficiency,warp_execution_efficiency,shared_load_transactions_per_request,gld_transactions_per_request,\
shared_load_transactions,gld_transactions,dram_read_transactions,global_hit_rate,gld_requested_throughput,gld_throughput,dram_read_throughput,\
shared_load_throughput,gld_efficiency,dram_utilization,shared_utilization,shared_efficiency,global_load_requests"


# 数据集列表
# datasets=("As-Caida" "P2p-Gnutella31" "Email-EuAll" "Soc-Slashdot0922" "Web-NotreDame" "Com-Dblp" "Amazon0601" "RoadNet-CA" "Wiki-Talk" \
# "Web-BerkStan" "As-Skitter" "Cit-Patents" "Soc-Pokec" "Sx-Stackoverflow" "Com-Lj" "Soc-LiveJ" "Com-Orkut" "Twitter7" "Com-Friendster")
 
datasets=("Web-NotreDame" "Com-Dblp" "Amazon0601" "RoadNet-CA" "Wiki-Talk" "Imdb-2021" 
         "Web-BerkStan" "As-Skitter" "Cit-Patents" "Soc-Pokec" "Sx-Stackoverflow" "Com-Lj"
         "Soc-LiveJ" "k-mer-graph5" "Hollywood-2011" "Com-Orkut" "Enwiki-2024" 
         "k-mer-graph4" "Twitter7" "Com-Friendster"
         )

# datasets=("cluster2-s20-e2" "cluster2-s20-e4" "cluster2-s20-e8" "cluster2-s20-e16" "cluster2-s20-e32" "cluster2-s20-e64" "cluster2-s20-e128" "cluster2-s20-e256" "cluster2-s20-e512" "cluster2-s20-e1024")
# datasets=("cluster4-s17-e32" "cluster4-s18-e32" "cluster4-s19-e32" "cluster4-s20-e32" "cluster4-s21-e32" "cluster4-s22-e32" "cluster4-s23-e32" "cluster4-s24-e32")

# datasets=("k-mer-graph4" "k-mer-graph5" "MAWI-graph4" "MAWI-graph5" "Gsh-2015-host" "It-2004" "Sk-2005" "Webbase-2001" "Enwiki-2024")
# datasets=("Hollywood-2011" "Imdb-2021")

# 算法函数：每个算法一个函数，传入对应的配置文件和内核名称
run_algorithm() {
    local algorithm_name=$1
    local config_file=$2
    local kernel_name=$3
    local dataset_name

    mkdir -p $LOG_DIR/${algorithm_name}
    cache_file="$LOG_DIR/${algorithm_name}/cache_prof.txt"
    output_file="$LOG_DIR/${algorithm_name}/prof_output.txt"


    # 遍历数据集并执行命令
    for dataset_name in "${datasets[@]}"; do
        echo "Running $algorithm_name on dataset: $dataset_name"
        # 执行 nvprof 命令
        sudo $CUDA_PATH --csv --log-file $cache_file --kernels $kernel_name --metrics $METRICS $EXEC_PATH -config=$config_file -dataset=$dataset_name
        cat $cache_file >> $output_file
    done
}

# 运行不同的算法

# run_algorithm "Bisson"              "./config/config-bisson.ini"       "triangleCountKernel" 
# run_algorithm "Fox"                 "./config/config-fox.ini"          "binSearchKernel" 
# run_algorithm "Green"               "./config/config-green.ini"        "count_all_trianglesGPU" 
run_algorithm "GroupTC-Cuckoo"      "./config/config-grouptc-cuckoo.ini" "grouptc_cuckoo" 
# run_algorithm "GroupTC-HASH-V2"     "./config/config-grouptc-hash-v2.ini" "grouptc_hash_v2" 
# run_algorithm "GroupTC-HASH"        "./config/config-grouptc-hash.ini" "grouptc_hash" 
# run_algorithm "GroupTC-OPT"         "./config/config-grouptc-opt.ini"  "grouptc_with_*" 
# run_algorithm "GroupTC"             "./config/config-grouptc.ini"      "grouptc" 
# run_algorithm "H-INDEX"             "./config/config-h-index.ini"      "warp_hash_count" 
# run_algorithm "Hu"                  "./config/config-hu.ini"           "triangleCountKernel" 
# run_algorithm "Polak"               "./config/config-polak.ini"        "calculate_triangles" 
# run_algorithm "TriCore"             "./config/config-tricore.ini"      "warp_binary_kernel" 
# run_algorithm "TRUST"               "./config/config-trust.ini"        "trust" 

echo "All algorithms have completed."
