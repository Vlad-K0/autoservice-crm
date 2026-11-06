# Title: M1-3 VehicleOwnership: периоды владения с EXCLUDE-констрейнтом

---

**Этап:** M1 — Ядро CRM · **Модуль:** `crm-clients` · **Размер:** M · **Зависимости:** M1-1, M1-2

## Что делаем

Связь «клиент ↔ авто» многие-ко-многим **во времени**: у авто бывает несколько
владельцев, пересечение периодов одного авто недопустимо. Паттерн — из обзора §3.1
(AXTTON CORE, периоды `titularidad`; Vtiger — история владения).

**Миграция `V4__ownership.sql`:**

```sql
CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE vehicle_ownership (
    id         bigserial PRIMARY KEY,
    client_id  bigint NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    vehicle_id bigint NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    valid_from date NOT NULL DEFAULT current_date,
    valid_until date,            -- NULL = владеет сейчас
    created_at  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE vehicle_ownership
    ADD CONSTRAINT ownership_no_overlap
    EXCLUDE USING gist (
        vehicle_id WITH =,
        daterange(valid_from, COALESCE(valid_until, 'infinity'::date)) WITH &&
    );
```

**Код:** сущность `VehicleOwnership`, репозиторий, сервис:

- `assign(clientId, vehicleId, from, until)` — текущее владение закрывает предыдущее;
- `currentOwner(vehicleId)` — активный владелец;
- `ownersHistory(vehicleId)` — все периоды.

## Готово, когда

- [ ] Пересекающиеся периоды одного авто отклоняются **на уровне БД** (интеграционный тест ловит нарушение)
- [ ] Разные авто — пересечения допустимы (тест)
- [ ] Передача авто: новый период открыт, старый закрыт датой (тест сценария)
- [ ] `make test` зелёный

## Подсказки

- Ловить нарушение констрейнта в сервисе и превращать в понятную ошибку
  («авто уже в собственности у X до Y») — Spring обернёт его в `DataIntegrityViolationException`.
- Это первая задача уровня «сделать парой» (из предложения по первой итерации) — тонкое место домена, стоит обсудить модель вместе.
