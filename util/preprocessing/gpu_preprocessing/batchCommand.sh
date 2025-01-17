/usr/local/cuda-11.4/bin/nvcc  CSR2DCSR.cu -o CSR2DCSR
/usr/local/cuda-11.4/bin/nvcc  CSR2RidDCSR.cu -o CSR2RidDCSR
/usr/local/cuda-11.4/bin/nvcc  CSR2TrustSortDCSR.cu -o CSR2TrustSortDCSR
/usr/local/cuda-11.4/bin/nvcc  CSR2TrustNSortDCSR.cu -o CSR2TrustNSortDCSR


# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/As-Caida/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/As-Caida/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/P2p-Gnutella31/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/P2p-Gnutella31/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Email-EuAll/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Email-EuAll/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Slashdot0922/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Soc-Slashdot0922/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Web-NotreDame/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Web-NotreDame/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Dblp/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Com-Dblp/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Amazon0601/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Amazon0601/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/RoadNet-CA/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/RoadNet-CA/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Wiki-Talk/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Wiki-Talk/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Web-BerkStan/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Web-BerkStan/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/As-Skitter/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/As-Skitter/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Cit-Patents/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Cit-Patents/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Pokec/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Soc-Pokec/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Sx-Stackoverflow/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Sx-Stackoverflow/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Lj/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Com-Lj/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-LiveJ/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Soc-LiveJ/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Orkut/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Com-Orkut/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Twitter7/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Twitter7/  >>  dcsr_preprocess.txt
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Friendster/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/Com-Friendster/  >>  dcsr_preprocess.txt


./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/As-Caida/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/As-Caida/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/P2p-Gnutella31/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/P2p-Gnutella31/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Email-EuAll/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Email-EuAll/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Slashdot0922/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Soc-Slashdot0922/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Web-NotreDame/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Web-NotreDame/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Dblp/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Com-Dblp/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Amazon0601/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Amazon0601/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/RoadNet-CA/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/RoadNet-CA/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Wiki-Talk/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Wiki-Talk/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Web-BerkStan/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Web-BerkStan/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/As-Skitter/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/As-Skitter/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Cit-Patents/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Cit-Patents/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Pokec/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Soc-Pokec/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Sx-Stackoverflow/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Sx-Stackoverflow/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Lj/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Com-Lj/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-LiveJ/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Soc-LiveJ/  >>  rid_dcsr_preprocess.txt
./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Orkut/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Com-Orkut/  >>  rid_dcsr_preprocess.txt
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Twitter7/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Twitter7/  >>  rid_dcsr_preprocess.txt
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Friendster/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/Com-Friendster/  >>  rid_dcsr_preprocess.txt



# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/As-Caida/        ~/cuda_project/TC-compare-V100/data/trust_dataset/As-Caida/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/P2p-Gnutella31/        ~/cuda_project/TC-compare-V100/data/trust_dataset/P2p-Gnutella31/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Email-EuAll/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Email-EuAll/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Slashdot0922/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Soc-Slashdot0922/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Web-NotreDame/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Web-NotreDame/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Dblp/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Com-Dblp/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Amazon0601/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Amazon0601/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/RoadNet-CA/        ~/cuda_project/TC-compare-V100/data/trust_dataset/RoadNet-CA/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Wiki-Talk/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Wiki-Talk/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Web-BerkStan/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Web-BerkStan/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/As-Skitter/        ~/cuda_project/TC-compare-V100/data/trust_dataset/As-Skitter/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Cit-Patents/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Cit-Patents/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Pokec/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Soc-Pokec/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Sx-Stackoverflow/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Sx-Stackoverflow/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Lj/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Com-Lj/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-LiveJ/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Soc-LiveJ/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Orkut/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Com-Orkut/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Twitter7/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Twitter7/  >>  tns_csr_preprocess.txt
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Friendster/        ~/cuda_project/TC-compare-V100/data/trust_dataset/Com-Friendster/  >>  tns_csr_preprocess.txt



# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/As-Caida/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/As-Caida/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/P2p-Gnutella31/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/P2p-Gnutella31/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Email-EuAll/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Email-EuAll/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Slashdot0922/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Soc-Slashdot0922/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Web-NotreDame/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Web-NotreDame/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Dblp/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Com-Dblp/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Amazon0601/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Amazon0601/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/RoadNet-CA/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/RoadNet-CA/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Wiki-Talk/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Wiki-Talk/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Web-BerkStan/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Web-BerkStan/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/As-Skitter/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/As-Skitter/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Cit-Patents/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Cit-Patents/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Pokec/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Soc-Pokec/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Sx-Stackoverflow/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Sx-Stackoverflow/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Lj/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Com-Lj/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Soc-LiveJ/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Soc-LiveJ/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Orkut/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Com-Orkut/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Twitter7/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Twitter7/  >>  ts_csr_preprocess.txt
# ./CSR2TrustSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/Com-Friendster/        ~/cuda_project/TC-compare-V100/data/trust_sort_dataset/Com-Friendster/  >>  ts_csr_preprocess.txt





# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e8/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e8/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e16/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e16/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e24/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e24/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e32/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e32/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e40/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e40/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e48/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e48/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e56/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e56/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e64/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e64/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e72/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e72/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e80/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s16-e80/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e8/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e8/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e16/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e16/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e24/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e24/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e32/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e32/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e40/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e40/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e48/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e48/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e56/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e56/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e64/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e64/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e72/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e72/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e80/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s17-e80/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e8/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e8/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e16/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e16/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e24/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e24/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e32/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e32/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e40/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e40/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e48/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e48/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e56/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e56/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e64/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e64/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e72/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e72/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e80/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s18-e80/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e8/         ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e8/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e16/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e16/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e24/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e24/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e32/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e32/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e40/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e40/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e48/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e48/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e56/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e56/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e64/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e64/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e72/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e72/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e80/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s19-e80/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e8/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e8/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e16/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e16/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e24/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e24/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e32/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e32/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e40/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e40/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e48/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e48/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e56/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e56/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e64/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e64/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e72/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e72/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e80/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s20-e80/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e8/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e8/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e16/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e16/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e24/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e24/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e32/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e32/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e40/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e40/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e48/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e48/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e56/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e56/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e64/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e64/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e72/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e72/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e80/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s21-e80/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e8/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e8/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e16/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e16/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e24/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e24/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e32/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e32/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e40/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e40/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e48/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e48/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e56/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e56/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e64/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e64/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e72/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e72/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e80/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s22-e80/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e8/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e8/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e16/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e16/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e24/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e24/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e32/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e32/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e40/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e40/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e48/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e48/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e56/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e56/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e64/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e64/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e72/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e72/ 
# ./CSR2DCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e80/        ~/cuda_project/TC-compare-V100/data/dcsr_dataset/s23-e80/ 




# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e8/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e8/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e16/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e16/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e24/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e24/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e32/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e32/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e40/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e40/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e48/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e48/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e56/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e56/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e64/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e64/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e72/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e72/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e80/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s16-e80/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e8/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e8/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e16/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e16/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e24/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e24/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e32/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e32/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e40/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e40/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e48/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e48/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e56/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e56/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e64/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e64/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e72/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e72/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e80/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s17-e80/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e8/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e8/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e16/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e16/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e24/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e24/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e32/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e32/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e40/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e40/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e48/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e48/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e56/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e56/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e64/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e64/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e72/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e72/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e80/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s18-e80/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e8/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e8/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e16/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e16/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e24/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e24/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e32/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e32/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e40/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e40/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e48/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e48/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e56/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e56/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e64/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e64/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e72/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e72/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e80/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s19-e80/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e8/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e8/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e16/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e16/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e24/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e24/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e32/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e32/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e40/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e40/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e48/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e48/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e56/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e56/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e64/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e64/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e72/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e72/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e80/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s20-e80/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e8/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e8/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e16/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e16/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e24/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e24/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e32/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e32/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e40/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e40/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e48/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e48/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e56/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e56/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e64/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e64/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e72/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e72/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e80/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s21-e80/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e8/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e8/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e16/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e16/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e24/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e24/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e32/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e32/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e40/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e40/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e48/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e48/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e56/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e56/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e64/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e64/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e72/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e72/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e80/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s22-e80/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e8/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e8/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e16/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e16/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e24/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e24/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e32/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e32/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e40/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e40/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e48/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e48/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e56/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e56/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e64/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e64/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e72/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e72/ 
# ./CSR2RidDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e80/        ~/cuda_project/TC-compare-V100/data/rid_dcsr_dataset/s23-e80/ 


# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e8/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e8/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e16/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e16/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e24/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e24/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e32/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e32/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e40/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e40/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e48/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e48/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e56/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e56/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e64/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e64/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e72/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e72/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s16-e80/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s16-e80/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e8/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e8/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e16/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e16/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e24/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e24/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e32/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e32/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e40/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e40/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e48/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e48/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e56/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e56/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e64/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e64/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e72/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e72/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s17-e80/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s17-e80/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e8/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e8/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e16/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e16/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e24/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e24/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e32/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e32/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e40/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e40/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e48/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e48/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e56/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e56/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e64/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e64/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e72/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e72/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s18-e80/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s18-e80/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e8/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e8/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e16/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e16/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e24/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e24/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e32/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e32/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e40/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e40/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e48/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e48/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e56/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e56/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e64/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e64/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e72/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e72/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s19-e80/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s19-e80/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e8/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e8/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e16/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e16/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e24/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e24/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e32/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e32/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e40/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e40/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e48/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e48/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e56/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e56/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e64/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e64/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e72/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e72/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s20-e80/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s20-e80/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e8/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e8/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e16/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e16/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e24/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e24/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e32/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e32/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e40/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e40/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e48/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e48/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e56/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e56/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e64/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e64/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e72/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e72/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s21-e80/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s21-e80/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e8/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e8/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e16/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e16/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e24/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e24/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e32/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e32/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e40/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e40/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e48/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e48/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e56/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e56/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e64/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e64/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e72/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e72/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s22-e80/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s22-e80/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e8/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e8/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e16/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e16/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e24/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e24/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e32/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e32/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e40/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e40/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e48/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e48/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e56/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e56/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e64/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e64/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e72/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e72/ 
# ./CSR2TrustNSortDCSR ~/cuda_project/TC-compare-V100/data/csr_dataset/s23-e80/        ~/cuda_project/TC-compare-V100/data/trust_dataset/s23-e80/ 