.PHONY: help \
config \
build \
clean-upd \
composer-install \
install \
install-profile \
uninstall \
artisan-migrate \
up \
upd \
upd-all \
status \
stop \
deploy \
shell \
shell-db \
root-shell

.DEFAULT_GOAL := help

# Project settings
APP_CONTAINER=laracastdl
APP_CONTAINER_DOCROOT=/var/www/html

# Set dir of Makefile to a variable to use later
MAKEPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PWD := $(dir $(MAKEPATH))

USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)

# Read project .env
ifeq ("$(wildcard .env)",".env")
	include .env
endif

help: ## ❓ * Show help (Default task)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

config: ## ⤵️  Step 1. configuring project and git
	touch .env.example
	cp -f .env.example .env
	echo UID=$(USER_ID) >> .env
	echo GID=$(GROUP_ID) >> .env

build: ## ⤵️  Step 2. Build docker services
	docker-compose -p laracasts-downloader build

build-no-cache: ## ⤵️  Alternative step 2. Build docker services without cache
	docker-compose -p laracasts-downloader build --no-cache

clean-upd: ## ⤵️  Step 3. Run containers in the background with --remove-orphans
	docker-compose -p laracasts-downloader up -d --remove-orphans

composer-install: ## ⤵️  Step 4. Install vendor packages (see composer.json for exact location)
	docker exec -it -u $(USER_ID):$(GROUP_ID) -w $(APP_CONTAINER_DOCROOT) $(APP_CONTAINER) composer install --ignore-platform-reqs

install: config build clean-upd composer-install ## ⚡ Automating setup steps
	@echo 💚 Install OK
	@echo ⚠️ Do not forget to set your Laracasts account details in your .env file.
	@echo 💚 Then you can enter into the app\'s container with make shell, then php ./start.php [OPTIONS]

uninstall: ## 🗑️  Remove Docker containers and vendor packages, .env, built assets, etc.
	docker-compose -p laracasts-downloader down --volumes
	rm -f .env
	rm -rf vendor

up: ## 🟢🎺 Run containers in the foreground
	docker-compose -p laracasts-downloader up --remove-orphans

upd: ## 🟢👻 Run laracasts-downloader containers in the background
	docker-compose -p laracasts-downloader up -d --remove-orphans

status: ## ℹ️  Show network and short container status
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.State}}"

stop: ## 🛑 Stop laracasts-downloader containers
	docker-compose -p laracasts-downloader stop

shell: ## 🗔  Open shell in the app container
	docker exec -it -u $(USER_ID):$(GROUP_ID) -w $(APP_CONTAINER_DOCROOT) $(APP_CONTAINER) bash

root-shell: ## 🗔  Open root shell in the app container
	docker exec -it -w $(APP_CONTAINER_DOCROOT) $(APP_CONTAINER) bash
