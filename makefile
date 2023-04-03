IMG_NAME="6828-labenv:v1"
CONER_NAME=6828-labenv
LOG_LEVEL=3
LOG_FILE="log.txt"

run: 
	@sh/run.sh $(CONER_NAME) $(LOG_LEVEL) $(LOG_FILE) 0

run-gdb:
	@sh/run.sh $(CONER_NAME) $(LOG_LEVEL) $(LOG_FILE) 1

mkenv: Dockerfile
	@sh/mkenv.sh $(IMG_NAME) $(CONER_NAME) $(LOG_LEVEL) $(LOG_FILE)

clean:
	rm -rf log.txt
	@sudo docker ps -a | grep $(CONER_NAME) 1>/dev/null 2>/dev/null; if [ $$? -eq 0 ]; then sudo docker rm $(CONER_NAME) -f 1>/dev/null 2>/dev/null; fi
	@sudo docker images | grep $(IMG_NAME) 1>/dev/null 2>/dev/null; if [ $$? -eq 0 ]; then sudo docker rmi $(IMG_NAME) 1>/dev/null 2>/dev/null; fi