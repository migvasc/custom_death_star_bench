
#idle

echo 'idle for 5 min'
date > idle.txt && sleep 5m

# heating up 
wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 1000 -P

# very low -> 1 req por s
echo 'RUNNING 1reqs'  
sleep 1m && echo 'running very low load 1 RPS' > 1reqs.txt && date >> 1reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 1 -P >> 1reqs.txt
mv 0.txt 0_1reqs.txt

# low load
echo 'RUNNING 10reqs'  
sleep 1m && echo 'running low load 10 RPS' > 10reqs.txt && date >> 10reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 10reqs.txt
mv 0.txt 0_10reqs.txt

# low load
echo 'RUNNING 20reqs'  
sleep 1m && echo 'running low load 20 RPS' > 20reqs.txt && date >> 20reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 20reqs.txt
mv 0.txt 0_20reqs.txt

# low load
echo 'RUNNING 30reqs'  
sleep 1m && echo 'running low load 30 RPS' > 30reqs.txt && date >> 30reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 30reqs.txt
mv 0.txt 0_30reqstxt

# low load
echo 'RUNNING 40reqs'  
sleep 1m && echo 'running low load 40 RPS' > 40reqs.txt && date >> 40reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 40reqs.txt
mv 0.txt 0_40reqs.txt

# low load
echo 'RUNNING 50reqs'  
sleep 1m && echo 'running low load 50 RPS' > 50reqs.txt && date >> 50reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 50reqs.txt
mv 0.txt 0_50reqs.txt

# low load
echo 'RUNNING 60reqs'  
sleep 1m && echo 'running low load 60 RPS' > 60reqs.txt && date >> 60reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 60reqstxt
mv 0.txt 0_60reqs.txt

echo 'RUNNING 70reqs'  
sleep 1m && echo 'running low load 70 RPS' > 70reqs.txt && date >> 70reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 70reqstxt
mv 0.txt 0_70reqs.txt

echo 'RUNNING 80reqs'  
sleep 1m && echo 'running low load 80 RPS' > 80reqs.txt && date >> 80reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 80reqstxt
mv 0.txt 0_80reqs.txt

echo 'RUNNING 90reqs'  
sleep 1m && echo 'running low load 90 RPS' > 90reqs.txt && date >> 90reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 90reqstxt
mv 0.txt 0_90reqs.txt

echo 'RUNNING 100reqs'  
sleep 1m && echo 'running low load 100 RPS' > 100reqs.txt && date >> 100reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 100reqstxt
mv 0.txt 0_100reqs.txt

echo 'RUNNING 1000reqs'  
sleep 1m && echo 'running low load 1000 RPS' > 1000reqs.txt && date >> 1000reqs.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> 1000reqstxt
mv 0.txt 0_1000reqs.txt

echo 'finished'!
