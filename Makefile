include .env

CERTIFICATE = $(CERT) $(KEY)

all: up

up: $(CERTIFICATE)
	docker build -t nginx-tls-alpine srcs/nginx
	docker run --name alpine-nginx -p 443:443 nginx-tls-alpine

$(CERTIFICATE):
	@openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(KEY) -out $(CERT) -subj "/C=$(CERT_COUNTRY)/L=$(CERT_LOCATION)/O=$(CERT_ORG)/OU=$(CER_ORG_UNITY)/CN=$(DOMAIN_NAME)"
	@echo -e "$(GREEN)Created self-signed certificate$(DEFAULT)"

clean:
	rm -rf $(CERTIFICATE)

clean_docker:
	docker stop alpine-nginx
	docker rm alpine-nginx
	docker rmi nginx-tls-alpine

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
	@echo "$(BOLD)$(YELLOW)Git:$(WHITE) Adding all archives.$(DEFAULT)"
	@git commit -m "[$(DATETIME)] - Little changes by $(USER)"
	@echo "$(BOLD)$(CYAN)Git:$(WHITE) Commit this changes \
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

.PHONY : all clean fclean re git