#VARIABLES
#You can change any of the following parameters with other data and it will continue to work

#DOMAIN
#If you change the domain name you must execute "make host" after the change. Be careful, this will change the hosts file.
DOMAIN_NAME=javiersa.42.fr

#CERTIFICATE
CRT_COUNTRY=ES
CRT_LOCATION=Malaga
CRT_ORG=42
CRT_ORG_UNITY=student

#DATABASE
DB_NAME = db_$(subst .,_,$(DOMAIN_NAME))
DB_USER=javiersa
DB_PASS:=$(shell openssl rand -base64 12)
DB_ROOT_PASS:=$(shell openssl rand -base64 12)
DB_HOST=mariadb

#WORDPRESS
ADMIN_USER=javiersa
ADMIN_PASS:=$(shell openssl rand -base64 12)
ADMIN_EMAIL=javiersa@student.42malaga.com


#OTHER
MSSG_DIR=/dev/null

###################################################################################################################################

#ENVS
ENV_MARIADB=srcs/.env_mariadb
ENV_NGINX=srcs/.env_nginx
ENV_WORDPRESS=srcs/.env_wordpress
ENVS = $(ENV_MARIADB) $(ENV_NGINX) $(ENV_WORDPRESS)

all: host up

up: $(ENVS)
	@docker-compose -f ./srcs/docker-compose.yml up -d --build
	@echo -e "\n$(GREEN)╔════════════════════════════║COMMANDS║═══════════════════════════════╗$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make logs $(BLUE) To see the containers logs                             $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make ls $(BLUE)   To see the containers, images and networks             $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make down $(BLUE) Stop all the services in docker compose                $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make clean $(BLUE)Remove crts, containers, images, volumes and networks  $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make re $(BLUE)   Restart the docker compose                             $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make host $(BLUE) Put the domain name in the host file                   $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make prune $(BLUE) Remove all unused data in docker                      $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make logs-wp $(BLUE)To see the wordpress container logs                  $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make logs-nginx $(BLUE)To see the nginx container logs                   $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make logs-mariadb $(BLUE)To see the mariadb container logs               $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)╚═════════════════════════════════════════════════════════════════════╝$(DEFAULT)\n"

down: $(ENVS)
	@docker-compose -f ./srcs/docker-compose.yml down

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs

logs-wp:
	@docker-compose -f ./srcs/docker-compose.yml logs wordpress
logs-nginx:
	@docker-compose -f ./srcs/docker-compose.yml logs nginx
logs-mariadb:
	@docker-compose -f ./srcs/docker-compose.yml logs mariadb

ls:
	@echo -e "\n$(BLUE)CONTAINERS:$(DEFAULT)"
	@docker ps -a
	@echo -e "\n$(YELLOW)IMAGES:$(DEFAULT)"
	@docker images
	@echo -e "\n$(GREEN)NETWORKS:$(DEFAULT)"
	@docker network ls
	@echo -e "\n"


clean: down
	@echo -e "$(GREEN)✔$(DEFAULT) Cointainers $$(docker ps -qa | tr '\n' ' '): $(GREEN)Stopped$(DEFAULT)"; docker stop $$(docker ps -qa) >$(MSSG_DIR) 2>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Cointainers $$(docker ps -qa | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker rm $$(docker ps -qa) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Images $$(docker images -qa | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker rmi -f $$(docker images -qa) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Volumes $$(docker volume ls -q | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker volume rm $$(docker volume ls -q) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Networks $$(docker network ls --format "{{.ID}}: {{.Name}}" | grep -v -E '(bridge|host|none)' | tr ':' ','): $(GREEN)Deleted$(DEFAULT)"; docker network rm $$(docker network ls --format "{{.ID}}: {{.Name}}" | grep -v -E '(bridge|host|none)') >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true
	@rm -rf $(ENVS)
	@echo -e "$(GREEN)✔$(DEFAULT) Envs: $(GREEN)Deleted$(DEFAULT)"

host:
	@if ! grep -q "$(DOMAIN_NAME)" /etc/hosts; then \
		echo -e "$(RED)✘$(DEFAULT) Hosts: $(RED)Not found$(DEFAULT)" && \
		echo -e "$(GREEN)Adding $(DOMAIN_NAME) to /etc/hosts...$(DEFAULT)" && \
        echo "127.0.0.1 $(DOMAIN_NAME) www.$(DOMAIN_NAME)" >> /etc/hosts; \
        echo -e "$(GREEN)✔$(DEFAULT) Hosts: $(GREEN)Updated$(DEFAULT)"; \
    else \
        echo -e "$(GREEN)✔$(DEFAULT) Hosts: $(GREEN)Already up-to-date$(DEFAULT)"; \
    fi

re: down up

prune:
	@docker system prune -a -f

$(ENV_MARIADB):
	@echo -e "#MARIADB" > $(ENV_MARIADB)
	@echo -e "DB_NAME=$(DB_NAME)" >> $(ENV_MARIADB)
	@echo -e "DB_USER=$(DB_USER)" >> $(ENV_MARIADB)
	@echo -e "DB_PASS=$(DB_PASS)" >> $(ENV_MARIADB)
	@echo -e "DB_ROOT_PASS=$(DB_ROOT_PASS)" >> $(ENV_MARIADB)

$(ENV_NGINX):
	@echo -e "#NGINX" > $(ENV_NGINX)
	@echo -e "DOMAIN_NAME=$(DOMAIN_NAME)" >> $(ENV_NGINX)
	@echo -e "CRT_COUNTRY=$(CRT_COUNTRY)" >> $(ENV_NGINX)
	@echo -e "CRT_LOCATION=$(CRT_LOCATION)" >> $(ENV_NGINX)
	@echo -e "CRT_ORG=$(CRT_ORG)" >> $(ENV_NGINX)
	@echo -e "CRT_ORG_UNITY=$(CRT_ORG_UNITY)" >> $(ENV_NGINX)
	
$(ENV_WORDPRESS):
	@echo -e "#WORDPRESS" > $(ENV_WORDPRESS)
	@echo -e "DOMAIN_NAME=$(DOMAIN_NAME)" >> $(ENV_WORDPRESS)
	@echo -e "DB_NAME=$(DB_NAME)" >> $(ENV_WORDPRESS)
	@echo -e "DB_USER=$(DB_USER)" >> $(ENV_WORDPRESS)
	@echo -e "DB_PASS=$(DB_PASS)" >> $(ENV_WORDPRESS)
	@echo -e "ADMIN_USER=$(ADMIN_USER)" >> $(ENV_WORDPRESS)
	@echo -e "ADMIN_PASS=$(ADMIN_PASS)" >> $(ENV_WORDPRESS)
	@echo -e "ADMIN_EMAIL=$(ADMIN_EMAIL)" >> $(ENV_WORDPRESS)
	@echo -e "DB_HOST=$(DB_HOST)" >> $(ENV_WORDPRESS)

###################################################################################################################################

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

.PHONY : all clean re up down ls logs host git logs-wp logs-nginx logs-mariadb prune