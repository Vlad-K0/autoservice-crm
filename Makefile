# Короткие команды для разработки. Список целей: `make help`.

# Значения по умолчанию; переопределяются файлом .env (шаблон: .env.example).
POSTGRES_DB ?= crm
POSTGRES_USER ?= crm
POSTGRES_PASSWORD ?= crm
POSTGRES_PORT ?= 5432
-include .env
export

.PHONY: help up down psql run test

help: ## Показать список команд
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-8s\033[0m %s\n", $$1, $$2}'

up: ## Поднять PostgreSQL (docker compose)
	docker compose up -d

down: ## Остановить PostgreSQL
	docker compose down

psql: ## Консоль psql внутри контейнера
	docker compose exec postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

run: ## Запустить backend (crm-api); подключение к БД — из .env / дефолтов
	cd backend && \
	mvn -q -DskipTests install && \
	SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:$(POSTGRES_PORT)/$(POSTGRES_DB) \
	SPRING_DATASOURCE_USERNAME=$(POSTGRES_USER) \
	SPRING_DATASOURCE_PASSWORD=$(POSTGRES_PASSWORD) \
	mvn spring-boot:run -pl crm-api

test: ## Прогнать тесты backend
	cd backend && mvn verify

mock: ## Мок-сервер API из контракта (Prism, http://localhost:4010)
	docker run --rm --name crm-mock -p 4010:4010 \
		-v $(PWD)/docs/openapi:/spec:ro \
		stoplight/prism:4 mock -h 0.0.0.0 /spec/crm-api.yaml

swagger: ## Swagger UI для контракта (http://localhost:8082; Try-it-out против make mock)
	docker run --rm --name crm-swagger -p 8082:8080 \
		-e SWAGGER_JSON=/spec/crm-api.yaml \
		-v $(PWD)/docs/openapi:/spec:ro \
		swaggerapi/swagger-ui:latest
