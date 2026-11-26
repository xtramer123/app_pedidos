# API Pedidos Almuerzos (FastAPI + MySQL)

API REST con FastAPI, SQLAlchemy, Pydantic y autenticación JWT (Bearer). Crea automáticamente la base de datos `pedidos`, las tablas `usuario` y `almuerzo`, y carga 5 datos de prueba idempotentes al iniciar.

## Estructura

```text
API/
  app/
    core/          # Configuración .env y seguridad JWT/bcrypt
    db/            # Conexión MySQL, creación de BD, seed
    dependencies/  # Dependencia de autenticación
    models/        # Modelos SQLAlchemy
    routers/       # Endpoints auth y almuerzos
    schemas/       # Esquemas Pydantic
    main.py        # App FastAPI y lifespan
  .env.example
  requirements.txt
  README.md
```

## Requisitos

- Python 3.10+
- MySQL Server en ejecución

## Instalación

Desde la carpeta `API`:

```powershell
cd C:\Users\IsaacPC\Documents\APPpedidos-PC\app_pedidos\API
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## Configuración `.env`

Copia `.env.example` a `.env` y ajusta credenciales:

```powershell
Copy-Item .env.example .env
```

Variables:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=tu_password
DB_NAME=pedidos

JWT_SECRET_KEY=cambia_esta_clave_por_una_segura_y_larga
JWT_ALGORITHM=HS256
JWT_ACCESS_TOKEN_EXPIRE_MINUTES=60
```

## Levantar servidor

```powershell
uvicorn app.main:app --reload
```

La API quedará en `http://127.0.0.1:8000`. Documentación interactiva: `http://127.0.0.1:8000/docs`.

## Comportamiento de inicialización

Al iniciar:

1. Verifica si existe la base `pedidos`; si no existe, la crea.
2. Crea tablas `usuario` y `almuerzo` si no existen.
3. Inserta un usuario seed (`seed@pedidos.local`) y 5 almuerzos de prueba si aún no existen esos 5 registros para ese usuario. El seed es idempotente.

## Autenticación JWT

Los endpoints de `/almuerzos` requieren:

```http
Authorization: Bearer <token>
```

Errores esperados:
- `401`: token ausente, inválido o expirado; credenciales inválidas en login.
- `404`: almuerzo no existe o no pertenece al usuario autenticado.
- `400/422`: validaciones o body inválido.

## Endpoints

### Auth (públicos)

- `POST /auth/register` - registra usuario y devuelve JWT.
  ```json
  {
    "nombre": "Juan Encargado",
    "email": "juan@example.com",
    "password": "secreto123",
    "rol": "USER"
  }
  ```
- `POST /auth/login` - valida credenciales y devuelve JWT.
  ```json
  {
    "email": "juan@example.com",
    "password": "secreto123"
  }
  ```

Respuesta token:
```json
{
  "access_token": "...",
  "token_type": "bearer"
}
```

### Almuerzos (requieren Bearer token)

- `GET /almuerzos` - lista pedidos del usuario autenticado; incluye `total = cantidad * precio`.
- `GET /almuerzos/{id}` - obtiene pedido por id (solo si pertenece al usuario).
- `POST /almuerzos` - crea pedido. `fecha_pedido` la asigna la API; `entregado` inicia en `false`.
  ```json
  {
    "cliente": "Cliente Demo",
    "plato": "Arroz con pato",
    "cantidad": 2,
    "precio": 18.50
  }
  ```
- `PUT /almuerzos/{id}` - actualiza campos enviados y/o marca `entregado`.
  ```json
  {
    "entregado": true
  }
  ```
- `DELETE /almuerzos/{id}` - anula/elimina pedido. Responde `204`.

## Modelo de datos

### `usuario`
- `id` bigint PK autoincrement
- `nombre` varchar(100) not null
- `email` varchar(120) not null unique
- `password` varchar(100) not null (bcrypt hash)
- `rol` varchar(20) not null default `USER` (`ADMIN` o `USER`)

### `almuerzo`
- `id` bigint PK autoincrement
- `cliente` varchar(100) not null
- `plato` varchar(100) not null
- `cantidad` int not null, > 0
- `precio` decimal(8,2) not null, > 0
- `fecha_pedido` date not null (asignado por API)
- `entregado` boolean not null default false
- `usuario_id` bigint FK -> `usuario.id` not null
