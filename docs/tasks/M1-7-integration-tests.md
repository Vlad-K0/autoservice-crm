# Title: M1-7 Интеграционные тесты ядра CRM (Testcontainers)

---

**Этап:** M1 — Ядро CRM · **Модули:** `crm-clients` + `crm-api` · **Размер:** M · **Зависимости:** M1-1…M1-6

## Что делаем

Поднимаем тестовую инфраструктуру, которая будет жить до конца проекта:
реальная PostgreSQL в Docker вместо моков — иначе не проверить ни констрейнт
периодов (M1-3), ни уникальность VIN (M1-2), ни миграции.

**Технически:**

- зависимость `org.testcontainers:postgresql` + `junit-jupiter` (test scope) в `crm-api`
  (версиями управляет spring-boot-starter-parent);
- базовый класс для тестов:

```java
@SpringBootTest
@Testcontainers
abstract class IntegrationTest {
    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");
}
```

  `@ServiceConnection` (Spring Boot 3.1+) сам подставит креды контейнера в datasource;

- тесты гоняются через `mvn verify` → CI прогоняет их автоматически на каждый PR.

**Покрыть:**

- CRUD клиентов/авто + телефоны;
- поиск из M1-5 (все типы запросов);
- констрейнт периодов владения (пересечение отклоняется);
- уникальность VIN;
- REST: 404/400/409 в формате RFC 7807;
- миграции накатываются с нуля на чистой базе.

## Готово, когда

- [ ] Тесты поднимают реальную PostgreSQL и проходят локально (`make test`)
- [ ] CI зелёный с тестами (проверить на любом PR)
- [ ] Перечисленные сценарии покрыты
- [ ] Время прогона тестов < ~2 минут (базу переиспользуем между тестами через контекст)

## Подсказки

- На CI (GitHub Actions ubuntu) Docker есть из коробки — Testcontainers работают без доп. настройки.
- Если тесты станут медленными: один контейнер на модуль тестов, `@ServiceConnection` + singleton context кэшируется Spring'ом.
