# autoservice-crm

CRM для автосервиса: клиенты и автомобили с историей обслуживаний, заказ-наряды,
склад запчастей, запись и календарь.

**Статус:** каркас (этап 0 roadmap — структура репозитория, CI, окружение).

Обзор open-source аналогов, доменная модель и roadmap — в
[docs/research/oss-crm-survey.md](docs/research/oss-crm-survey.md).

## Структура репозитория

```
backend/     Java 21, Spring Boot, Maven multi-module (модули = домены)
frontend/    фронтенд (стек фиксируется ADR-0003)
docs/        ADR (архитектурные решения), research, инструкции
.github/     CI и шаблон PR
```

## Быстрый старт

Нужны: JDK 21, Maven 3.9+, Docker.

```bash
make up    # поднять PostgreSQL (docker compose)
make run   # запустить backend (crm-api)
```

- Health: http://localhost:8080/actuator/health
- Swagger UI: http://localhost:8080/swagger-ui.html

Параметры БД (имя, пользователь, пароль, порт) переопределяются через `.env`
в корне — скопируйте шаблон: `cp .env.example .env`.

## Документация

- [docs/adr](docs/adr) — архитектурные решения (ADR)
- [docs/development.md](docs/development.md) — настройка окружения с нуля
- [CONTRIBUTING.md](CONTRIBUTING.md) — процесс работы: ветки, PR, Definition of Done

## Roadmap

0. Каркас: структура репозитория, CI, окружение (вы здесь)
1. Ядро CRM: клиенты, автомобили, история обслуживаний
2. Каталог работ/запчастей и заказ-наряды (смета, статусная машина)
3. Календарь записи: слоты, ресурсы, онлайн-запись
4. Склад: остатки, резерв под наряд, reorder
5. Счета и документы: PDF, акты приёмки/выдачи
6. Уведомления: подтверждения записи, напоминания
7. Второй эшелон: фото приёмки, QR-подписи, портал клиента, отчёты
