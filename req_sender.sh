
#idle

echo 'idle for 5 min'
date > idle.txt && sleep 5m

# heating up 
wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 1000 -P

# very low -> 1 req por s
echo 'RUNNING VERY LOW'  
sleep 1m && echo 'running very low load 1 RPS' > very_low.txt && date >> very_low.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 1 -P >> very_low.txt
mv 0.txt 0_very_low.txt

# low load
echo 'RUNNING LOW'  
sleep 1m && echo 'running low load 10 RPS' > low.txt && date >> low.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 10 -P >> low.txt
mv 0.txt 0_low.txt

# medium 
echo 'RUNNING MEDIUM'  
sleep 1m && echo 'running medium load 100 RPS' > medium.txt && date >> medium.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 100 -P >> medium.txt
mv 0.txt 0_medium.txt

# high
echo 'RUNNING HIGH'  
sleep 1m && echo 'running high load 1000 RPS' > high.txt && date >> high.txt && wrk2/wrk -D exp -t 1 -c 1 -d 300 -L -s "$1" "$2" -R 1000 -P >> high.txt
mv 0.txt 0_high.txt

echo 'finished'!
