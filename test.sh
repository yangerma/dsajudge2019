while [ "$(cat /tmp/log | grep finished | wc -c)" == 0 ]; do
	sleep(5)
	echo attempt >>/tmp/count
	echo finished >/tmp/log
done
