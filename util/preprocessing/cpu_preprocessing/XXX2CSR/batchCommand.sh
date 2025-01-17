#https://snap.stanford.edu/data/
g++ SNAP2CSR.cpp -o SNAP2CSR

g++ TSV2CSR.cpp -o TSV2CSR

#https://github.com/graph500/graph500/tree/graph500-2.1.4
g++ G5002CSR.cpp -o G5002CSR

# https://law.di.unimi.it/datasets.php
g++ WebGraph2CSR.cpp -o WebGraph2CSR

#snap twitter7
#https://github.com/ANLAB-KAIST/traces/releases/tag/twitter_rv.net
g++ MTX2CSR.cpp -o MTX2CSR

#https://graphchallenge.mit.edu/data-sets
g++ GraphChallenge2CSR.cpp -o GraphChallenge2CSR

#https://www.cc.gatech.edu/dimacs10/archive/kronecker.shtml
g++ Dimacs2CSR.cpp -o Dimacs2CSR

# ./SNAP2CSR /home/LiJB/data/snap_dataset/Soc-Pokec/soc-pokec-relationships.txt                   /home/LiJB/data/csr_dataset/Soc-Pokec/
# ./G5002CSR /home/LiJB/data/g500_214_dataset/balance-s15-e8.bin    /home/LiJB/data/csr_dataset/balance-s15-e8/

# ./MTX2CSR /home/LiJB/data/twitter/twitter7/twitter7.mtx                 /home/LiJB/data/csr_dataset/Twitter7/
# ./GraphChallenge2CSR /home/LiJB/data/gc_dataset/Graph500-Scale18-Ef16/graph500-scale18-ef16_adj.mmio             /home/LiJB/data/csr_dataset/Graph500-Scale18-Ef16/
# ./Dimacs2CSR /home/LiJB/data/kron_dataset/Kron_16/kron_g500-simple-logn16.graph                /home/LiJB/data/csr_dataset/Kron_16/

# ./TSV2CSR   ~/cuda_project/TC-compare-V100/data/tsv_dataset/graph500-scale24-ef16/data.tsv       ~/cuda_project/TC-compare-V100/data/csr_dataset/graph500-scale24-ef16/
# ./TSV2CSR   ~/cuda_project/TC-compare-V100/data/tsv_dataset/graph500-scale25-ef16/data.tsv       ~/cuda_project/TC-compare-V100/data/csr_dataset/graph500-scale25-ef16/
# ./TSV2CSR   ~/cuda_project/TC-compare-V100/data/tsv_dataset/k-mer-graph4/data.tsv       ~/cuda_project/TC-compare-V100/data/csr_dataset/k-mer-graph4/
# ./TSV2CSR   ~/cuda_project/TC-compare-V100/data/tsv_dataset/k-mer-graph5/data.tsv       ~/cuda_project/TC-compare-V100/data/csr_dataset/k-mer-graph5/
# ./TSV2CSR   ~/cuda_project/TC-compare-V100/data/tsv_dataset/MAWI-graph4/data.tsv       ~/cuda_project/TC-compare-V100/data/csr_dataset/MAWI-graph4/
# ./TSV2CSR   ~/cuda_project/TC-compare-V100/data/tsv_dataset/MAWI-graph5/data.tsv       ~/cuda_project/TC-compare-V100/data/csr_dataset/MAWI-graph5/




# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/As-Caida/as-caida20071105.txt        /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/As-Caida/      
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/P2p-Gnutella31/p2p-Gnutella31.txt        /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/P2p-Gnutella31/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Email-EuAll/email-EuAll.txt        /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Email-EuAll/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Soc-Slashdot0922/soc-Slashdot0902.txt     /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Slashdot0922/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Web-NotreDame/web-NotreDame.txt     /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Web-NotreDame/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Com-Dblp/com-dblp.ungraph.txt    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Com-Dblp/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Amazon0601/amazon0601.txt     /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Amazon0601/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/RoadNet-CA/roadNet-CA.txt     /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/RoadNet-CA/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Wiki-Talk/wiki-Talk.txt     /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Wiki-Talk/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Web-BerkStan/web-BerkStan.txt     /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Web-BerkStan/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/As-Skitter/as-skitter.txt     /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/As-Skitter/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Cit-Patents/cit-Patents.txt     /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Cit-Patents/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Soc-Pokec/soc-pokec-relationships.txt    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Soc-Pokec/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Sx-Stackoverflow/sx-stackoverflow.txt    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Sx-Stackoverflow/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Com-Lj/com-lj.ungraph.txt    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Com-Lj/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Soc-LiveJ/soc-LiveJournal1.txt    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Soc-LiveJ/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Com-Orkut/com-orkut.ungraph.txt    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Com-Orkut/
# ./MTX2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Twitter7/twitter7/twitter7.mtx                /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Twitter7/
# ./SNAP2CSR /home/LiJB/cuda_project/TC-compare-V100/data/snap_dataset/Com-Friendster/com-friendster.ungraph.txt   /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/Com-Friendster/



# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e8.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e8/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e16.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e16/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e24.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e24/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e32.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e32/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e40.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e40/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e48.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e48/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e56.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e56/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e64.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e64/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e72.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e72/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s16-e80.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s16-e80/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e8.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e8/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e16.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e16/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e24.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e24/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e32.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e32/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e40.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e40/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e48.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e48/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e56.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e56/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e64.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e64/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e72.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e72/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s17-e80.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s17-e80/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e8.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e8/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e16.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e16/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e24.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e24/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e32.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e32/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e40.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e40/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e48.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e48/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e56.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e56/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e64.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e64/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e72.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e72/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s18-e80.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s18-e80/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e8.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e8/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e16.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e16/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e24.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e24/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e32.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e32/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e40.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e40/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e48.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e48/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e56.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e56/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e64.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e64/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e72.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e72/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s19-e80.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s19-e80/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e8.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e8/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e16.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e16/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e24.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e24/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e32.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e32/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e40.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e40/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e48.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e48/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e56.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e56/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e64.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e64/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e72.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e72/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s20-e80.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s20-e80/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e8.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e8/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e16.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e16/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e24.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e24/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e32.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e32/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e40.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e40/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e48.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e48/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e56.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e56/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e64.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e64/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e72.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e72/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s21-e80.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s21-e80/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e8.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e8/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e16.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e16/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e24.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e24/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e32.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e32/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e40.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e40/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e48.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e48/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e56.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e56/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e64.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e64/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e72.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e72/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s22-e80.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s22-e80/
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e8.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e8/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e16.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e16/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e24.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e24/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e32.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e32/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e40.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e40/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e48.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e48/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e56.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e56/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e64.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e64/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e72.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e72/   &
# ./G5002CSR /home/LiJB/cuda_project/TC-compare-V100/data/g500_dataset/s23-e80.bin    /home/LiJB/cuda_project/TC-compare-V100/data/csr_dataset/s23-e80/   &


# ./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/gsh-2015-host/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/Gsh-2015-host/
# ./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/it-2004/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/It-2004/
# ./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/sk-2005/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/Sk-2005/
# ./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/webbase-2001/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/Webbase-2001/
# ./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/enwiki-2024/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/Enwiki-2024/
# ./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/gsh-2015-tpd/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/Gsh-2015-tpd/
# ./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/uk-2005/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/Uk-2005/
# ./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/hollywood-2011/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/Hollywood-2011/
./WebGraph2CSR /home/LiJB/cuda_project/TC-compare-V100/dataset_app/g500_dataset/imdb-2021/edges.bin   /home/LiJB/cuda_project/TC-compare-V100/dataset_app/csr_dataset/Imdb-2021/




