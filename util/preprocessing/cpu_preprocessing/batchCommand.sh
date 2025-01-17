# g++ CSR2DCSR.cpp -o CSR2DCSR
# g++ CSR2RidDCSR.cpp -o CSR2RID_DCSR
# g++ CSR2TrustCSR.cpp -o CSR2TRUST
g++ CSR2HuEdgeList.cpp -o CSR2HU
# g++ CSR2PolakEdgeList.cpp -o CSR2POLAK
# g++ G5002CSR.cpp -o G5002CSR


# ./CSR2HU /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Com-Orkut/        /home/LiJB/cuda_project/TC-compare-V100/data/hu_dataset/Com-Orkut/   
./CSR2HU /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Twitter7/        /home/LiJB/cuda_project/TC-compare-V100/data/hu_dataset/Twitter7/   
# ./CSR2HU /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Com-Friendster/       /home/LiJB/cuda_project/TC-compare-V100/data/hu_dataset/Com-Friendster/  


# ./CSR2RID_DCSR ../../data/csr_dataset/Twitter7/        ../../data/rid_dcsr_dataset/Twitter7/   
# ./CSR2RID_DCSR ../../data/csr_dataset/Com-Friendster/        ../../data/rid_dcsr_dataset/Com-Friendster/  