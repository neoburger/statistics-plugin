while true; do
	docker run -it --rm --name neoburger -v "$(pwd)":/app neoburger/statistics:1.0 bash /app/run-node-self.sh
	sleep 3600; 
done
