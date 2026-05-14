Estás trabajando en wger, una app Flutter de fitness open-source.
- Flutter SDK >=3.10.0
- State management: Provider (legacy) + Riverpod (migración activa)
- DB local: Drift/SQLite
- HTTP: WgerBaseProvider (lib/providers/)
- Backend REST: https://wger-master.rge.uber.space (user/flutteruser)
- Guía de migración: RIVERPOD_MIGRATION_PATTERN.md

Antes de cualquier cambio:
1. Leé el archivo relevante completo
2. Respetá el patrón Provider vs Riverpod según el módulo
3. No rompas contratos de API existentes
4. Mantené compatibilidad con los 35+ idiomas (no hardcodees strings)