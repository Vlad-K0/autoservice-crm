# Окружение с нуля

## Что нужно

| Инструмент | Версия | Установка (macOS) |
|---|---|---|
| JDK | 21+ | `brew install --cask temurin@21` (или SDKMAN: `sdk install java 21-tem`) |
| Maven | 3.9+ | `brew install maven` |
| Docker | любая | Docker Desktop |

## Поднять проект

```bash
make up      # PostgreSQL в docker (база crm, пользователь crm/crm, порт 5432)
make run     # backend: crm-api на localhost:8080
make test    # тесты backend
make psql    # консоль БД
```

Проверка: http://localhost:8080/actuator/health — `{"status":"UP"}`.
Swagger UI: http://localhost:8080/swagger-ui.html.

## Конфигурация

Параметры docker compose (имя БД, пользователь, пароль, порт) читаются из `.env`
в корне репозитория; шаблон — `.env.example`:

```bash
cp .env.example .env   # необязательно: без .env работают значения по умолчанию
```

Пароль PostgreSQL применяется только при **первой** инициализации тома — смена
позже не действует, том нужно пересоздать (см. раздел ниже).

Значения по умолчанию — в `backend/crm-api/src/main/resources/application.yml`.
Для локальных секретов создайте `application-local.yml` рядом (он в `.gitignore`)
и запускайте с профилем: `mvn spring-boot:run -pl crm-api -Dspring-boot.run.profiles=local`.

`make run` подставляет переменные `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`,
`SPRING_DATASOURCE_PASSWORD` из тех же значений, из которых поднята база
(`.env` / дефолты) — приложение и docker compose всегда сходятся в кредах.
При запуске из IDEA переменные можно задать в Run Configuration либо положиться
на дефолты из `application.yml` (они совпадают с дефолтами compose).

## Пересоздать базу с нуля

```bash
make down
docker volume rm autoservice-crm_crm-pgdata   # имя тома: <каталог>_crm-pgdata
make up
```
