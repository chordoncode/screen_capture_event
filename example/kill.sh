PID=`ps -ef|grep device-id | grep main.dart | awk '{print $2}'`
echo $PID
kill -9 $PID

