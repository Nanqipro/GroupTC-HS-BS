# ./prof-fox.sh
./prof-grouptc-opt.sh
./prof-grouptc.sh
# ./prof-hu.sh
# ./prof-tricore.sh
./prof-trust.sh
./prof-trust-new.sh
# ./prof-polak.sh



# sudo /usr/local/cuda-11.3/bin/ncu   --csv --log-file /home/LiJB/cuda_project/TC-compare-V100/log/grouptc/cache_prof.txt  --kernel-name grouptc  --metrics sm__warps_active.avg.pct_of_peak_sustained_active,smsp__thread_inst_executed_per_inst_executed.pct,l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_ld.ratio,l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum,l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum,smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct  /home/LiJB/cuda_project/TC-compare-V100/approach/GroupTC/grouptc  /home/LiJB/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/As-Caida/   1  1 >>  /home/LiJB/cuda_project/TC-compare-V100/log/grouptc/xxx_output.txt  && cat /home/LiJB/cuda_project/TC-compare-V100/log/grouptc/cache_prof.txt >> /home/LiJB/cuda_project/TC-compare-V100/log/grouptc/prof_output.txt 