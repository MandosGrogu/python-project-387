# Карта решений: Спецификация приложения

## Destination

Утверждённая спецификация приложения «Календарь звонков», по которой можно раскладывать тикеты. Спецификация должна быть полной, однозначной и готовой к разбиению на задачи реализации.

## Notes

- Домен: сервис бронирования 30-минутных слотов, без авторизации
- Текущее состояние: `docs/specification.md` (markdown), `docs/openapi.yaml` (OpenAPI 3.0), `main.tsp` (TypeSpec, аспирационный)
- Существующий код: Django HTML-представления, без REST API
- Термины: CONTEXT.md
- Навыки: grilling, domain-modeling

## Decisions so far

- [Тикет 004: Покрытие валидации в спецификации](tickets/004-validation-coverage.md): все 5 правил валидации описаны в OpenAPI; пробелы — границы рабочих часов, проверка прошедшего времени только при создании, авто-генерация recording_url. Отчёт: [research/004-validation-coverage.md](research/004-validation-coverage.md)
- [Тикет 001: Канонический формат спецификации](tickets/001-canonical-format.md): канонический формат — OpenAPI (`docs/openapi.yaml`); TypeSpec и markdown не канонические.
- [Тикет 002: Объём спецификации — HTML и API](tickets/002-scope-html-and-api.md): спецификация описывает только REST API; HTML-интерфейс в неё не входит.
- [Тикет 003: Статус main.tsp](tickets/003-main-tsp-status.md): main.tsp — будущее направление развития API (типы событий EventType), не устаревший дизайн.
- [Тикет 005: Детализация модели данных](tickets/005-data-model-detail.md): модель данных описана достаточно детально для раскладывания тикетов; дополнительные сущности не нужны.
- [Тикет 006: Критерии приёмки спецификации](tickets/006-acceptance-criteria.md): полнота — три слоя (Data/Logic/UI), edge cases, NFR, GIVEN-WHEN-THEN; однозначность — конкретика, глоссарий, RFC 2119 (MUST/SHOULD/MAY), визуальные схемы.
- [Тикет 007: Описание ошибок и граничных случаев](tickets/007-error-handling.md): универсальная схема ошибки в `components` + `$ref`, `examples` в путях, жёсткий формат `date-time`, DST — текстом в `description`, часовой пояс — через IANA (tz database).
- [Тикет 008: Стратегия миграции от HTML к API](tickets/008-migration-strategy.md): нужна спецификация миграции от HTML-страниц к REST API.

## Not yet specified

- Нужна ли спецификация для админ-интерфейса (Django admin)?
- Требуется ли версионирование API?

## Out of scope

<!-- работа за пределами назначения карты -->

## Completed

Все тикеты реализованы и закрыты в GitHub Issues (#2–#9). Спецификация утверждена.
