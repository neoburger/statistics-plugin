while true; do
	docker run -it --rm --name neoburger -e 'key={YOURKEY}' -v "$(pwd)":/app neoburger/statistics:v3.4.0
	sleep 36000; 
done
