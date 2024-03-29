#VARIABLES
#You can change any of the following parameters with other data and it will continue to work

#DOMAIN
ALUMNI=javiersa
DOMAIN_NAME=$(ALUMNI).42.fr

#CERTIFICATE
CRT_COUNTRY=ES
CRT_LOCATION=Malaga
CRT_ORG=42
CRT_ORG_UNITY=student

#DATABASE
DB_NAME = db_$(subst .,_,$(DOMAIN_NAME))
DB_USER=$(ALUMNI)
DB_PASS:=$(shell openssl rand -base64 12)
DB_ROOT_PASS:=$(shell openssl rand -base64 12)

#WORDPRESS
ADMIN_USER=$(ALUMNI)
ADMIN_PASS:=$(shell openssl rand -base64 12)
ADMIN_EMAIL=$(ALUMNI)@student.42malaga.com

#FTP
FTP_USER=$(ALUMNI)
FTP_PASS:=$(shell openssl rand -base64 12)

#REDIS
REDIS_PASS:=$(shell openssl rand -base64 12)

#NETDATA
NETDATA_USR=javiersa
NETDATA_PASS:=$(shell openssl rand -base64 12)

#OTHER
MSSG_DIR=/dev/null

###################################################################################################################################

#VOLUMES
VOLUMES_DIR=/home/$(ALUMNI)/data/volumes
WP_VOLUME=$(VOLUMES_DIR)/web
DB_VOLUME=$(VOLUMES_DIR)/db
VOLUMES = $(WP_VOLUME) $(DB_VOLUME)
#VOLUME REFERENCES
VOLUME_REF = ./volumes

#ENVS
ENV_GENERAL=srcs/.env_general
ENV_DB=srcs/.env_db
ENV_WORDPRESS=srcs/.env_wordpress
ENVS = $(ENV_DB) $(ENV_GENERAL) $(ENV_WORDPRESS)

#DOCKER COMPOSE
DOCKER_COMPOSE = export ALUMNI=$(ALUMNI); docker-compose -f ./srcs/docker-compose.yml
BONUS_DOCKER_COMPOSE = export ALUMNI=$(ALUMNI); docker-compose -f ./srcs_bonus/docker-compose.yml

define print_commands
	@echo -e "\n$(GREEN)╔════════════════════════════║COMMANDS║═══════════════════════════════╗$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make logs $(BLUE) To view the containers logs                            $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make ls $(BLUE)   To view the containers, images and networks            $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make down $(BLUE) Stop all the services in docker compose                $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make clean $(BLUE)Remove crts, containers, images, volumes and networks  $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make re $(BLUE)   Restart the docker compose                             $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make host $(BLUE) Put the domain name in the host file                   $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make prune $(BLUE) Remove all unused data in docker                      $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)║   $(MAGENTA)make logs service=___$(BLUE) To view the logs of a specific container    $(GREEN)║$(DEFAULT)"
	@echo -e "$(GREEN)╚═════════════════════════════════════════════════════════════════════╝$(DEFAULT)\n"
endef

define clean_docker
	@echo -e "$(GREEN)✔$(DEFAULT) Cointainers $$(docker ps -qa | tr '\n' ' '): $(GREEN)Stopped$(DEFAULT)"; docker stop $$(docker ps -qa) >$(MSSG_DIR) 2>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Cointainers $$(docker ps -qa | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker rm $$(docker ps -qa) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Images $$(docker images -qa | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker rmi -f $$(docker images -qa) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Volumes $$(docker volume ls -q | tr '\n' ' '): $(GREEN)Deleted$(DEFAULT)"; docker volume rm $$(docker volume ls -q) >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true ;\
	echo -e "$(GREEN)✔$(DEFAULT) Networks $$(docker network ls --format "{{.ID}}: {{.Name}}" | grep -v -E '(bridge|host|none)' | tr ':' ','): $(GREEN)Deleted$(DEFAULT)"; docker network rm $$(docker network ls --format "{{.ID}}: {{.Name}}" | grep -v -E '(bridge|host|none)') >>$(MSSG_DIR) 2>>$(MSSG_DIR) || true
endef

###################################################################################################################################

all: host up

up: $(ENVS) $(VOLUME_REF) $(VOLUMES)
	@$(DOCKER_COMPOSE) up --build -d --remove-orphans
	$(call print_commands)

down: $(ENVS)
	@$(DOCKER_COMPOSE) down --volumes --remove-orphans

logs:
	@$(DOCKER_COMPOSE) logs $(service)

ls:
	@echo -e "\n$(BLUE)CONTAINERS:$(DEFAULT)" && docker ps -a
	@echo -e "\n$(YELLOW)IMAGES:$(DEFAULT)" && docker images
	@echo -e "\n$(GREEN)NETWORKS:$(DEFAULT)" && docker network ls && echo -e "\n"

clean: down
	$(call clean_docker)
	@rm -rf $(ENVS) && echo -e "$(GREEN)✔$(DEFAULT) Envs: $(GREEN)Deleted$(DEFAULT)"
	@rm -rf $(VOLUMES_DIR) && echo -e "$(GREEN)✔$(DEFAULT) Volumes: $(GREEN)Deleted$(DEFAULT)"
	@rm -rf $(VOLUME_REF) && echo -e "$(GREEN)✔$(DEFAULT) Symlink: $(GREEN)Deleted$(DEFAULT)"

host:
	@if ! grep -q "$(DOMAIN_NAME)" /etc/hosts || ! grep -q "www.$(DOMAIN_NAME)" /etc/hosts || ! grep -q "web.$(DOMAIN_NAME)" /etc/hosts || ! grep -q "adminer.$(DOMAIN_NAME)" /etc/hosts || ! grep -q "netdata.$(DOMAIN_NAME)" /etc/hosts ; then \
		echo -e "$(RED)✘$(DEFAULT) Hosts: $(RED)Not found$(DEFAULT)" && \
		echo -e "$(GREEN)Adding $(DOMAIN_NAME) to /etc/hosts...$(DEFAULT)" && \
        echo "127.0.0.1 $(DOMAIN_NAME) www.$(DOMAIN_NAME) web.$(DOMAIN_NAME) adminer.$(DOMAIN_NAME) netdata.$(DOMAIN_NAME)" >> /etc/hosts && \
        echo -e "$(GREEN)✔$(DEFAULT) Hosts: $(GREEN)Updated$(DEFAULT)"; \
    else \
        echo -e "$(GREEN)✔$(DEFAULT) Hosts: $(GREEN)Already up-to-date$(DEFAULT)"; \
    fi

re: down up

prune:
	@docker system prune -a -f

$(ENV_GENERAL):
	@echo -e "#GENERAL DATA" > $(ENV_GENERAL)
	@echo -e "DOMAIN_NAME=$(DOMAIN_NAME)" >> $(ENV_GENERAL)
	@echo -e "CRT_COUNTRY=$(CRT_COUNTRY)" >> $(ENV_GENERAL)
	@echo -e "CRT_LOCATION=$(CRT_LOCATION)" >> $(ENV_GENERAL)
	@echo -e "CRT_ORG=$(CRT_ORG)" >> $(ENV_GENERAL)
	@echo -e "CRT_ORG_UNITY=$(CRT_ORG_UNITY)" >> $(ENV_GENERAL)

$(ENV_DB):
	@echo -e "#MARIADB" > $(ENV_DB)
	@echo -e "DB_NAME=$(DB_NAME)" >> $(ENV_DB)
	@echo -e "DB_USER=$(DB_USER)" >> $(ENV_DB)
	@echo -e "DB_PASS=$(DB_PASS)" >> $(ENV_DB)
	@echo -e "DB_ROOT_PASS=$(DB_ROOT_PASS)" >> $(ENV_DB)

$(ENV_WORDPRESS):
	@echo -e "#WORDPRESS" > $(ENV_WORDPRESS)
	@echo -e "ADMIN_USER=$(ADMIN_USER)" >> $(ENV_WORDPRESS)
	@echo -e "ADMIN_PASS=$(ADMIN_PASS)" >> $(ENV_WORDPRESS)
	@echo -e "ADMIN_EMAIL=$(ADMIN_EMAIL)" >> $(ENV_WORDPRESS)

$(VOLUMES_DIR):
	@mkdir -p $(VOLUMES_DIR)

$(VOLUMES):
	@mkdir -p $(VOLUMES)

$(VOLUME_REF):
	@ln -s $(VOLUMES_DIR) $(VOLUME_REF)

###################################################################################################################################

#BONUS
ENV_GENERAL_BONUS=srcs_bonus/.env_general
ENV_DB_BONUS=srcs_bonus/.env_db
ENV_WORDPRESS_BONUS=srcs_bonus/.env_wordpress
ENV_FTP=srcs_bonus/.env_ftp
ENVS_BONUS = $(ENV_GENERAL_BONUS) $(ENV_DB_BONUS) $(ENV_WORDPRESS_BONUS) $(ENV_FTP)

bonus: host bonus-up

bonus-up: $(ENVS_BONUS) $(VOLUME_REF) $(VOLUMES)
	@$(BONUS_DOCKER_COMPOSE) up --build -d --remove-orphans
	$(call print_commands)

bonus-down: $(ENVS_BONUS)
	@$(BONUS_DOCKER_COMPOSE) down --volumes --remove-orphans

bonus-logs:
	@$(BONUS_DOCKER_COMPOSE) logs $(service)

bonus-clean: bonus-down
	$(call clean_docker)
	@rm -rf $(ENVS_BONUS) && echo -e "$(GREEN)✔$(DEFAULT) Envs: $(GREEN)Deleted$(DEFAULT)"
	@rm -rf $(VOLUMES_DIR) && echo -e "$(GREEN)✔$(DEFAULT) Volumes: $(GREEN)Deleted$(DEFAULT)"
	@rm -rf $(VOLUME_REF) && echo -e "$(GREEN)✔$(DEFAULT) Symlink: $(GREEN)Deleted$(DEFAULT)"

bonus-re: bonus-down bonus-up

$(ENV_GENERAL_BONUS):
	@echo -e "#NGINX" > $(ENV_GENERAL_BONUS)
	@echo -e "DOMAIN_NAME=$(DOMAIN_NAME)" >> $(ENV_GENERAL_BONUS)
	@echo -e "CRT_COUNTRY=$(CRT_COUNTRY)" >> $(ENV_GENERAL_BONUS)
	@echo -e "CRT_LOCATION=$(CRT_LOCATION)" >> $(ENV_GENERAL_BONUS)
	@echo -e "CRT_ORG=$(CRT_ORG)" >> $(ENV_GENERAL_BONUS)
	@echo -e "CRT_ORG_UNITY=$(CRT_ORG_UNITY)" >> $(ENV_GENERAL_BONUS)
	@echo -e "NETDATA_USR=$(NETDATA_USR)" >> $(ENV_GENERAL_BONUS)
	@echo -e "NETDATA_PASS=$(NETDATA_PASS)" >> $(ENV_GENERAL_BONUS)

$(ENV_DB_BONUS):
	@echo -e "#MARIADB" > $(ENV_DB_BONUS)
	@echo -e "DB_NAME=$(DB_NAME)" >> $(ENV_DB_BONUS)
	@echo -e "DB_USER=$(DB_USER)" >> $(ENV_DB_BONUS)
	@echo -e "DB_PASS=$(DB_PASS)" >> $(ENV_DB_BONUS)
	@echo -e "DB_ROOT_PASS=$(DB_ROOT_PASS)" >> $(ENV_DB_BONUS)

$(ENV_WORDPRESS_BONUS):
	@echo -e "#WORDPRESS" > $(ENV_WORDPRESS_BONUS)
	@echo -e "ADMIN_USER=$(ADMIN_USER)" >> $(ENV_WORDPRESS_BONUS)
	@echo -e "ADMIN_PASS=$(ADMIN_PASS)" >> $(ENV_WORDPRESS_BONUS)
	@echo -e "ADMIN_EMAIL=$(ADMIN_EMAIL)" >> $(ENV_WORDPRESS_BONUS)
	@echo -e "REDIS_PASS=$(REDIS_PASS)" >> $(ENV_WORDPRESS_BONUS)

$(ENV_FTP):
	@echo -e "#FTP" > $(ENV_FTP)
	@echo -e "FTP_USER=$(FTP_USER)" >> $(ENV_FTP)
	@echo -e "FTP_PASS=$(FTP_PASS)" >> $(ENV_FTP)

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

.PHONY : all clean re up down ls logs host git prune \
		bonus bonus-up bonus-down bonus-logs bonus-clean bonus-re