# ADR-0001: Стек backend

- **Статус:** принято
- **Дата:** 2026-11-06

## Контекст

CRM для реального автосервиса. Команда — 2 разработчика, пишем с нуля;
наработки open-source берём только под permissive-лицензиями
(обзор: [docs/research/oss-crm-survey.md](../research/oss-crm-survey.md)).

## Решение

- **Java 21 (LTS)**, **Spring Boot 3.5.x**, **Maven** multi-module.
- **PostgreSQL 16**: нужны constraint `EXCLUDE` + `btree_gist` — непересекающиеся
  слоты записи и периоды владения авто (обзор §4).
- Миграции — **Flyway**; схема только через миграции, `ddl-auto=validate`.
- REST + **OpenAPI** (springdoc) — контракт согласуется до реализации.
- Spring Security + JWT; роли: Owner, Service Advisor, Technician, Parts Person, QC.
- Деньги — `BigDecimal`/копейки (minor units), никогда float/double.

## Последствия

- Предсказуемый стек с обширной документацией; модульность готова к росту.
- Перед стартом проверить свежую патч-версию Spring Boot 3.5.x
  (и не вышла ли стабильная Boot 4 — тогда пересмотреть этот ADR).

## Альтернативы (отклонены)

- **Gradle** — мощнее, но Maven проще и предсказуемее для команды из двух человек.
- **MySQL** — нет EXCLUDE-constraints для задач расписания.
