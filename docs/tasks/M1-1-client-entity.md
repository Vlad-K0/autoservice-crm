# Title: M1-1 Client: сущность, миграция, репозиторий

---

**Этап:** M1 — Ядро CRM · **Модуль:** `crm-clients` · **Размер:** M · **Зависимости:** M0-8 (JDK 21)

## Что делаем

Первая доменная сущность — клиент. Модель полей — из обзора
([../research/oss-crm-survey.md](../research/oss-crm-survey.md), §3.1).

**Миграция `V2__clients.sql`** (живёт в `crm-api/src/main/resources/db/migration/`):

- таблица `clients`:
  - `id` (bigserial PK), `client_type` (`PERSON` / `COMPANY`, not null),
  - `name` (not null — ФИО или название организации),
  - `email`, `address`, `acquisition_channel` (канал привлечения),
  - `marketing_consent` (boolean, default false),
  - `notes`, `created_at`, `updated_at`;
- таблица `client_phones` (`id`, `client_id` FK → clients ON DELETE CASCADE,
  `phone` not null, `is_primary` boolean) — телефонов у клиента несколько.

**Код в модуле `crm-clients`** (пакет `com.autoservice.crm.clients`):

- JPA-сущности `Client`, `ClientPhone`;
- Spring Data репозиторий `ClientRepository`;
- сервис `ClientService` с базовыми операциями (создать, обновить, получить, список с пагинацией).

REST здесь **не** делаем — это M1-4.

## Готово, когда

- [ ] Миграция V2 накатывается (`make up` → приложение стартует, `ddl-auto=validate` проходит)
- [ ] В `crm-clients` подключены зависимости `spring-boot-starter-data-jpa` и `spring-boot-starter-validation` (версии из parent)
- [ ] Сервис и репозиторий покрыты минимальным интеграционным тестом (создание клиента с двумя телефонами, чтение)
- [ ] `make test` зелёный

## Подсказки

- **Важно:** сущности лежат вне пакета приложения (`com.autoservice.crm.api`), поэтому в `CrmApplication`
  нужно добавить `@EntityScan("com.autoservice.crm")` и `@EnableJpaRepositories("com.autoservice.crm")`,
  иначе Hibernate их не увидит.
- Телефоны — отдельная таблица, не строка через запятую: по телефону будет поиск (M1-5).
- `client_type` через enum в Java + varchar в БД; констрейнт CHECK на 'PERSON','COMPANY'.
