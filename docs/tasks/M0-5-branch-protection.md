# Title: M0-5 Включить branch protection на main

---

**Этап:** M0 — Каркас · **Размер:** S · **Ответственный:** владелец репозитория · **Зависимости:** первый зелёный прогон CI

## Что делаем

Делаем процесс из CONTRIBUTING принудительным на уровне GitHub.

В репозитории: **Settings → Branches → Add branch protection rule → Branch name pattern: `main`**:

- ✅ Require a pull request before merging
  - ✅ Require approvals: **1**
- ✅ Require status checks to pass before merging
  - выбрать проверку **backend** (появится после первого зелёного прогона CI)
- ✅ Block force pushes
- ✅ Restrict deletions

## Готово, когда

- [ ] Прямой `git push` в `main` отклоняется
- [ ] PR нельзя смержить без approve второго разработчика
- [ ] PR нельзя смержить с красным CI
- [ ] Force push в `main` заблокирован

## Подсказки

- Если репозиторий на бесплатном плане приватный, часть правил может быть недоступна — тогда включаем то, что доступно, и discipline по CONTRIBUTING.
- Правило можно проверить безопасно: попробуйте запушить в main напрямую — должны получить отказ.
