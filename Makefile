DOCKER_COMPOSE=docker compose
DOCKER_COMPOSE_TOOLS=docker compose --profile tools
DOCKER_COMPOSE_ALL=docker compose --profile all

# Directories for projects
front-%: DIRECTORY="./front"
api-%: DIRECTORY="./api"

SUB_MAKE=$(MAKE) -C $(DIRECTORY)

install: compose.override.yaml api pull start api-install front front-install ## Install the full stack (clone api & front)

##
###--------------#
###    Docker    #
###--------------#
##

start: ## Start all containers
	$(DOCKER_COMPOSE) up -d

start-all: ## Create and start containers from all profiles
	$(DOCKER_COMPOSE_ALL) up -d

stop: ## Stop all containers
	$(DOCKER_COMPOSE_ALL) stop

down: ## Stop and remove containers and networks
	$(DOCKER_COMPOSE_ALL) down

down-clean: ## Stop and remove containers, networks and volumes (destructive)
	$(DOCKER_COMPOSE_ALL) down --volumes

pull: ## Pull service images
	$(DOCKER_COMPOSE) pull

remove: down-clean
	@echo -n "Are you sure about that ? [y/N] " && read ans && [ $${ans:-N} = y ]
	rm -rf api front

up: start ## Alias for up

.PHONY: start start-all stop down down-clean pull remove up

##
###-----------#
###    Api    #
###-----------#
##

api-start: ## Start the api containers
	$(SUB_MAKE) start

api-start-all: ## Start the api containers from all profiles (incl. tools)
	$(SUB_MAKE) start-all

api-sh: ## Connect to php container
	$(SUB_MAKE) sh

api-logs: ## Follow the api (php) container logs
	$(SUB_MAKE) logs

api-install: ## Install the api project
	$(SUB_MAKE) install

.PHONY: api-start api-start-all api-sh api-logs api-install

##
###-------------#
###    Front    #
###-------------#
##

front-start: ## Start the front containers
	$(SUB_MAKE) start

front-sh: ## Connect to node container
	$(SUB_MAKE) sh

front-logs: ## Follow the node container logs
	$(SUB_MAKE) logs

front-install: ## Install the front project
	$(SUB_MAKE) install

.PHONY: front-start front-sh front-logs front-install

##
###----------------------------#
###    Rules based on files    #
###----------------------------#
##

api: ## Clone the api repository into ./api
	git clone git@github.com:esportsvideos/api.git api

front: ## Clone the front (website) repository into ./front
	git clone git@github.com:esportsvideos/website.git front

compose.override.yaml: ## Create compose.override.yaml
	cp compose.override.yaml.dist compose.override.yaml

##
###--------------------#
###    Help & Others   #
###--------------------#
##

.DEFAULT_GOAL := help

help: ## Display help messages from Makefile
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-20s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

.PHONY: help
