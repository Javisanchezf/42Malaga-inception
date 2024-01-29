include .env

MSSG_DIR=/dev/null
CERTIFICATE = $(CERT) $(KEY)

all: up

up: $(CERTIFICATE)
	@service docker start 2>$(MSSG_DIR)
	@docker-compose -f ./srcs/docker-compose.yml up -d

down:
	@docker-compose -f ./srcs/docker-compose.yml down

$(CERTIFICATE):
	@openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(KEY) -out $(CERT) -subj "/C=$(CERT_COUNTRY)/L=$(CERT_LOCATION)/O=$(CERT_ORG)/OU=$(CER_ORG_UNITY)/CN=$(DOMAIN_NAME)"
	@echo -e "$(GREEN)✔$(DEFAULT) Self-signed certificate: $(GREEN)Created$(DEFAULT)"

clean: down
	@rm -rf $(CERTIFICATE); echo -e "$(GREEN)✔$(DEFAULT) Certificates : $(GREEN)Deleted$(DEFAULT)"
	@echo -e "$(GREEN)✔$(DEFAULT) Cointainers $$(docker ps -qa | tr '\n' ' '): $(GREEN)Stopped$(DEFAULT)"; docker stop $$(docker ps -qa) >$(MSSG_DIR) 2>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Cointainers $$(docker ps -qa | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker rm $$(docker ps -qa) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Images $$(docker images -qa | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker rmi -f $$(docker images -qa) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Volumes $$(docker volume ls -q | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker volume rm $$(docker volume ls -q) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Networks $$(docker network ls --format "{{.ID}}: {{.Name}}" | grep -v -E '(bridge|host|none)' | tr ':' ','): $(GREEN)Deleted$(DEFAULT)"; docker network rm $$(docker network ls --format "{{.ID}}: {{.Name}}" | grep -v -E '(bridge|host|none)') >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true

# Personal use variables
DATETIME := $(shell date +%Y-%m-%d' '%H:%M:%S)
USER := $(shell whoami)
GITIGNORE = .gitignore

#Personal use
$(GITIGNORE):
	@echo -e ".*\n*.out\n*.o\n*.a\n*.dSYM\n!.env\n!.dockerignore" > .gitignore
	@echo -e "$(GREEN)Creating:$(DEFAULT) Gitignore."
git: clean $(GITIGNORE)
	@git add *
	@git add .env
	@echo -e "$(BOLD)$(YELLOW)Git:$(WHITE) Adding all archives.$(DEFAULT)"
	@git commit -m "[$(DATETIME)] - Little changes by $(USER)"
	@echo -e "$(BOLD)$(CYAN)Git:$(WHITE) Commit this changes \
	 with "[$(DATETIME)] - Little changes by $(USER)".$(DEFAULT)"
	@git push
	@echo -e "$(BOLD)$(GREEN)Git:$(WHITE) Pushing all changes.$(DEFAULT)"

#COLORS
BOLD	:= \033[1m
BLACK	:= \033[30;1m
RED		:= \033[31;1m
GREEN	:= \033[32;1m
YELLOW	:= \033[33;1m
BLUE	:= \033[34;1m
MAGENTA	:= \033[35;1m
CYAN	:= \033[36;1m
WHITE	:= \033[37;1m
DEFAULT	:= \033[0m

.PHONY : all clean up down git