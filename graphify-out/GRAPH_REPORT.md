# Graph Report - app_pedidos  (2026-11-26)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 332 nodes · 470 edges · 28 communities (12 shown, 16 thin omitted)
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 15 edges (avg confidence: 0.95)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f7ad84fc`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- almuerzos.py
- profile_screen.dart
- home_screen.dart
- api_service.dart
- login_screen.dart
- main.dart
- pubspec.yaml
- routers/auth.py
- app_theme.dart
- almuerzo.dart
- usuario.dart
- analysis_options.yaml
- config.py
- api_config.dart
- widget_test.dart
- MainActivity.kt

## God Nodes (most connected - your core abstractions)
1. `Usuario` - 16 edges
2. `Base` - 8 edges
3. `Almuerzo` - 8 edges
4. `login()` - 8 edges
5. `register()` - 8 edges
6. `_get_owned_almuerzo()` - 7 edges
7. `seed_data()` - 7 edges
8. `dependencies` - 7 edges
9. `get_current_user()` - 6 edges
10. `create_almuerzo()` - 6 edges

## Surprising Connections (you probably didn't know these)
- `login()` --uses--> `Usuario`  [INFERRED]
  API/app/routers/auth.py → API/app/models/usuario.py
- `lifespan()` --uses--> `Base`  [INFERRED]
  API/app/main.py → API/app/db/database.py
- `_get_owned_almuerzo()` --uses--> `Almuerzo`  [INFERRED]
  API/app/routers/almuerzos.py → API/app/models/almuerzo.py
- `list_almuerzos()` --uses--> `Almuerzo`  [INFERRED]
  API/app/routers/almuerzos.py → API/app/models/almuerzo.py
- `get_current_user()` --uses--> `Usuario`  [INFERRED]
  API/app/dependencies/auth.py → API/app/models/usuario.py

## Import Cycles
- None detected.

## Communities (28 total, 16 thin omitted)

### Community 0 - "almuerzos.py"
Cohesion: 0.10
Nodes (20): decode_access_token(), Base, ensure_database_exists(), get_db(), seed_data(), get_current_user(), health(), lifespan() (+12 more)

### Community 1 - "profile_screen.dart"
Cohesion: 0.05
Nodes (34): _OrdersPage, _StateCard, build, email, entregados, _foodItem, _FoodPlateProfile, icon (+26 more)

### Community 2 - "home_screen.dart"
Cohesion: 0.06
Nodes (26): api, build, _cantidad, _cliente, color, _create, createState, _delete (+18 more)

### Community 3 - "api_service.dart"
Cohesion: 0.07
Nodes (24): ApiException, createAlmuerzo, _decode, deleteAlmuerzo, _error, getAlmuerzos, _headers, login (+16 more)

### Community 4 - "login_screen.dart"
Cohesion: 0.07
Nodes (24): api, build, createState, dispose, _email, _formKey, _loading, _obscure (+16 more)

### Community 5 - "main.dart"
Cohesion: 0.08
Nodes (23): _api, _authed, _bootstrap, build, createState, _handleAuthed, _handleLogout, initializeDateFormatting (+15 more)

### Community 6 - "pubspec.yaml"
Cohesion: 0.10
Nodes (20): dependencies, cupertino_icons, flutter, google_fonts, http, intl, shared_preferences, description (+12 more)

### Community 7 - "routers/auth.py"
Cohesion: 0.20
Nodes (10): create_access_token(), hash_password(), InvalidTokenError, verify_password(), login(), register(), LoginRequest, RegisterRequest (+2 more)

### Community 8 - "app_theme.dart"
Cohesion: 0.14
Nodes (11): AppColors, AppTheme, bg, border, danger, muted, primary, secondary (+3 more)

### Community 9 - "almuerzo.dart"
Cohesion: 0.17
Nodes (11): Almuerzo, cantidad, cliente, entregado, fechaPedido, fromJson, id, plato (+3 more)

### Community 10 - "usuario.dart"
Cohesion: 0.22
Nodes (7): email, fromJson, id, nombre, rol, toJson, Usuario

### Community 11 - "analysis_options.yaml"
Cohesion: 0.29
Nodes (6): analyzer, exclude, include, linter, rules, deprecated_member_use

## Knowledge Gaps
- **141 isolated node(s):** `build`, `email`, `entregados`, `_foodItem`, `icon` (+136 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 210 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **16 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `ApiService` connect `login_screen.dart` to `home_screen.dart`, `api_service.dart`, `main.dart`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **Are the 8 inferred relationships involving `Usuario` (e.g. with `get_current_user()` and `create_almuerzo()`) actually correct?**
  _`Usuario` has 8 INFERRED edges - model-reasoned connections that need verification._
- **What connects `build`, `email`, `entregados` to the rest of the system?**
  _141 weakly-connected nodes found - possible missing edges._
- **Should `almuerzos.py` be split into smaller, more focused modules?**
  _Cohesion score 0.09795918367346938 - nodes in this community are weakly interconnected._
- **Why does `SessionStore` connect `api_service.dart` to `main.dart`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Almuerzo` (e.g. with `_get_owned_almuerzo()` and `list_almuerzos()`) actually correct?**
  _`Almuerzo` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Should `profile_screen.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05353535353535353 - nodes in this community are weakly interconnected._