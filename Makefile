.PHONY: deploy-all stop-all restart-all update-dags logs-airflow logs-elasticsearch logs-fastapi clean-all setup-env clean-volumes clean-images help

# Default target
.DEFAULT_GOAL := help

# Colors for help messages
YELLOW := \033[1;33m
NC := \033[0m # No Color

# Docker commands with sudo
DOCKER := sudo docker
DOCKER_COMPOSE := sudo docker-compose

help:
	@echo "$(YELLOW)Available commands:$(NC)"
	@echo "  make deploy-all          - Start all containers"
	@echo "  make stop-all           - Stop all containers"
	@echo "  make restart-all        - Restart all containers"
	@echo "  make update-dags        - Update Airflow DAGs"
	@echo "  make logs-airflow       - View Airflow logs"
	@echo "  make logs-elasticsearch - View Elasticsearch logs"
	@echo "  make logs-fastapi       - View FastAPI logs"
	@echo "  make clean-all          - Stop and remove all containers, volumes, and images"
	@echo "  make clean-volumes      - Remove all Docker volumes"
	@echo "  make clean-images       - Remove all Docker images"
	@echo "  make setup-env          - Set up environment file"

deploy-all:
	$(DOCKER_COMPOSE) up

stop-all:
	$(DOCKER_COMPOSE) down

restart-all:
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) up -d

update-dags:
	$(DOCKER) cp ./dags/. airflow-webserver:/opt/airflow/dags
	$(DOCKER_COMPOSE) restart airflow-webserver airflow-scheduler

logs-airflow:
	$(DOCKER_COMPOSE) logs -f airflow-webserver airflow-scheduler

logs-elasticsearch:
	$(DOCKER_COMPOSE) logs -f elasticsearch

logs-fastapi:
	$(DOCKER_COMPOSE) logs -f fastapi

setup-env:
	cp .env.example .env
	echo "AIRFLOW_UID=$$(id -u)" >> .env

clean-all:
	@echo "Stopping and removing all Docker resources..."
	-$(DOCKER) stop $$($(DOCKER) ps -q)
	-$(DOCKER) rm $$($(DOCKER) ps -a -q)
	-$(DOCKER) rmi $$($(DOCKER) images -q)
	-$(DOCKER) volume rm $$($(DOCKER) volume ls -q)
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
	$(DOCKER) system prune -af --volumes
	@echo "Cleanup complete!"

clean-volumes:
	@echo "Removing all Docker volumes..."
	-$(DOCKER) volume rm $$($(DOCKER) volume ls -q)
	@echo "Volumes removed!"

clean-images:
	@echo "Removing all Docker images..."
	-$(DOCKER) rmi $$($(DOCKER) images -q)
	@echo "Images removed!"