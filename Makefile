# ============================================================
# Makefile for ElysiaJS + Bun project
# Supports development and production Docker workflows
# ============================================================

# ===================== Variables ============================
COMPOSE_FILE_DEV  = compose.dev.yaml
COMPOSE_FILE_PROD = compose.yaml
PROJECT_NAME_DEV  = llmos-dev
PROJECT_NAME      = llmos

# Colors for output
GREEN  = \033[0;32m
YELLOW = \033[1;33m
RED    = \033[0;31m
NC     = \033[0m # No Color

# ===================== PHONY ===============================
.PHONY: help \
dev-build dev-up dev-restart dev-down dev-stop dev-logs dev-shell dev-clean \
prod-build prod-up prod-restart prod-down prod-stop prod-logs prod-clean \
stop-all clean force-stop-dev force-stop-all \
ps npm-audit update-deps

# ===================== Help ================================
help: ## Show available commands
	@echo "$(GREEN)Available commands:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# ===================== Development =========================
dev-build: ## Build in development mode
	@echo "$(GREEN)Rebuilding and starting in development mode...$(NC)"
	docker compose -f $(COMPOSE_FILE_DEV) build

dev-up: ## Start in development mode in background
	@echo "$(GREEN)Starting in development mode in background...$(NC)"
	docker compose -f $(COMPOSE_FILE_DEV) up -d --build

dev-restart: ## Restart dev containers
	@echo "$(YELLOW)Restarting dev containers...$(NC)"
	docker compose -f $(COMPOSE_FILE_DEV) restart

dev-down: ## Stop dev containers
	@echo "$(YELLOW)Stopping dev containers...$(NC)"
	docker compose -f $(COMPOSE_FILE_DEV) down

dev-stop: ## Stop dev containers without removing them
	@echo "$(YELLOW)Stopping dev containers without removing...$(NC)"
	docker compose -f $(COMPOSE_FILE_DEV) stop

dev-logs: ## Show dev containers logs
	docker compose -f $(COMPOSE_FILE_DEV) logs -f

dev-shell: ## Enter dev container shell
	docker compose -f $(COMPOSE_FILE_DEV) exec server sh

dev-clean: ## Clean only dev containers
	@echo "$(RED)Cleaning dev containers...$(NC)"
	docker compose -f $(COMPOSE_FILE_DEV) down --rmi all --volumes --remove-orphans

# ===================== Production ==========================
prod-build: ## Build in production mode
	@echo "$(GREEN)Rebuilding and starting in production mode...$(NC)"
	docker compose -f $(COMPOSE_FILE_PROD) build

prod-up: ## Start in production mode in background
	@echo "$(GREEN)Starting in production mode in background...$(NC)"
	docker compose -f $(COMPOSE_FILE_PROD) up -d --build

prod-restart: ## Restart production containers
	@echo "$(YELLOW)Restarting production containers...$(NC)"
	docker compose -f $(COMPOSE_FILE_PROD) restart

prod-down: ## Stop production containers
	@echo "$(YELLOW)Stopping production containers...$(NC)"
	docker compose -f $(COMPOSE_FILE_PROD) down

prod-stop: ## Stop production containers without removing them
	@echo "$(YELLOW)Stopping production containers without removing...$(NC)"
	docker compose -f $(COMPOSE_FILE_PROD) stop

prod-logs: ## Show production containers logs
	docker compose -f $(COMPOSE_FILE_PROD) logs -f

prod-clean: ## Clean only production containers
	@echo "$(RED)Cleaning production containers...$(NC)"
	docker compose -f $(COMPOSE_FILE_PROD) down --rmi all --volumes --remove-orphans

# ===================== Common ==============================
stop-all: ## Stop all containers (dev and prod)
	@echo "$(YELLOW)Stopping all containers...$(NC)"
	docker ps -q --filter "name=$(PROJECT_NAME_DEV)" | xargs -r docker stop
	docker ps -q --filter "name=$(PROJECT_NAME)"     | xargs -r docker stop

clean: ## Clean all project containers and images
	@echo "$(RED)Cleaning all containers and images...$(NC)"
	docker compose -f $(COMPOSE_FILE_DEV) down --rmi all --volumes --remove-orphans
	docker compose -f $(COMPOSE_FILE_PROD) down --rmi all --volumes --remove-orphans

force-stop-dev: ## Force stop dev containers using docker stop
	@echo "$(RED)Force stopping dev containers...$(NC)"
	@docker ps -q --filter "name=$(PROJECT_NAME_DEV)" | xargs -r docker stop

force-stop-all: ## Force stop all project containers using docker stop
	@echo "$(RED)Force stopping all project containers...$(NC)"
	@docker ps -q --filter "name=$(PROJECT_NAME_DEV)" | xargs -r docker stop
	@docker ps -q --filter "name=$(PROJECT_NAME)"     | xargs -r docker stop

ps: ## Show running containers
	@echo "$(GREEN)Dev containers:$(NC)"
	docker ps --filter "name=$(PROJECT_NAME_DEV)"
	@echo "$(GREEN)Production containers:$(NC)"
	docker ps --filter "name=$(PROJECT_NAME)"

# ===================== Dependencies ========================
npm-audit: ## Check dependencies security
	docker compose -f $(COMPOSE_FILE_DEV) exec server yarn audit

update-deps: ## Update dependencies interactively
	docker compose -f $(COMPOSE_FILE_DEV) exec server yarn upgrade-interactive
