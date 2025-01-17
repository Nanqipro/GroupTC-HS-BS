# import os
# import shutil

# base_path = "/home/LiJB/data/polak_dataset/"
# files = os.listdir(base_path)

datasets = ["As-Caida","P2p-Gnutella31","Email-EuAll","Soc-Slashdot0922","Web-NotreDame","Com-Dblp","Amazon0601","RoadNet-CA","Wiki-Talk","Web-BerkStan","As-Skitter","Cit-Patents","Soc-Pokec","Sx-Stackoverflow","Com-Lj","Soc-LiveJ",
            "Com-Orkut",
            "Twitter7",
            "Com-Friendster",
            "graph500-scale24-ef16","graph500-scale25-ef16","k-mer-graph4","k-mer-graph5","MAWI-graph4","MAWI-graph5"
           ]

string = "sudo /usr/local/cuda-11.4/bin/nvprof --csv  --log-file /home/LiJB/cuda_project/TC-compare-V100/log/TRUST/cache_prof.txt  --kernels trust --metrics achieved_occupancy,branch_efficiency,warp_execution_efficiency,shared_load_transactions_per_request,gld_transactions_per_request,shared_load_transactions,gld_transactions,dram_read_transactions,global_hit_rate,gld_requested_throughput,gld_throughput,dram_read_throughput,shared_load_throughput,gld_efficiency,dram_utilization,shared_utilization,shared_efficiency,global_load_requests  /home/LiJB/cuda_project/TC-compare-V100/build/main -dataset=#{}  && cat /home/LiJB/cuda_project/TC-compare-V100/log/TRUST/cache_prof.txt >> /home/LiJB/cuda_project/TC-compare-V100/log/TRUST/prof_output.txt  "
for dataset in datasets:
    print(string.replace("#{}",dataset))
# for f in files:
#     if "edge"  in f:
#         f1 = f.replace("-edges","")
#         print(f1)
#         for dataset in datasets:
           
#             if dataset.lower() == f1:
#                 shutil.move(base_path+f,base_path+dataset)     

#         # f1 = f.replace(".bin","")
#         # os.makedirs(base_path+f1)
#         # shutil.move(base_path+f,base_path+f1+"/edges.bin") 

    