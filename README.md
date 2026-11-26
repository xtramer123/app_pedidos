# 📱 App Pedidos – Práctica de Taller de Desarrollo de Aplicaciones Móviles

Proyecto desarrollado como parte de la práctica del curso **Taller de Desarrollo de Aplicaciones Móviles**.  
Consiste en una aplicación móvil Android construida con **Flutter** y una **API REST** en **FastAPI + MySQL** para la gestión de pedidos de almuerzos.

---

## ✨ Descripción

**App Pedidos** permite a un encargado registrar y gestionar pedidos de almuerzos de forma simple y visual.  
La app incluye autenticación con JWT, manejo de sesión, y un perfil con diseño temático de “plato de comida”.

### Funcionalidades principales

- 🔐 **Registro e inicio de sesión** de usuarios.
- 📋 **Listado de pedidos** del usuario autenticado.
- ➕ **Creación de pedidos** (cliente, plato, cantidad, precio).
- ✅ **Marcar pedido como entregado / pendiente**.
- 🗑️ **Anulación de pedidos**.
- 👤 **Perfil de usuario** con estadísticas y diseño visual tipo plato.
- 💾 **Persistencia de sesión** con token JWT.

---

## 🎨 Diseño

Interfaz minimalista y agradable con una paleta basada en:

- 🟡 Amarillo
- 🟠 Naranja
- ⚪ Blanco

La pantalla de perfil presenta el avatar y datos del usuario dentro de un **plato de comida** decorativo, manteniendo coherencia visual con el tema de la app.

---

## 🛠️ Tecnologías utilizadas

### Mobile (Frontend)
- **Flutter / Dart**
- `http` – consumo de API REST
- `shared_preferences` – persistencia local de sesión
- `google_fonts` – tipografía
- `intl` – formato de fechas

### Backend (API)
- **Python / FastAPI**
- **SQLAlchemy** – ORM
- **Pydantic** – validación de datos
- **JWT (python-jose)** – autenticación
- **Passlib + bcrypt** – hash de contraseñas
- **MySQL / PyMySQL** – base de datos

---

## 📁 Estructura del proyecto

```text
app_pedidos/
├── API/                      # Backend FastAPI
│   ├── app/
│   │   ├── core/             # Configuración y seguridad JWT
│   │   ├── db/               # Conexión BD, creación y seed
│   │   ├── dependencies/     # Dependencias de autenticación
│   │   ├── models/           # Modelos SQLAlchemy
│   │   ├── routers/          # Endpoints auth y almuerzos
│   │   ├── schemas/          # Esquemas Pydantic
│   │   └── main.py           # Punto de entrada FastAPI
│   ├── .env.example
│   ├── requirements.txt
│   └── README.md
├── lib/                      # App Flutter
│   ├── core/                 # Config API y tema
│   ├── models/               # Modelos de datos
│   ├── screens/              # Pantallas (login, registro, home, perfil)
│   ├── services/             # API service y sesión
│   ├── widgets/              # Componentes reutilizables
│   └── main.dart
├── android/                  # Configuración Android
├── pubspec.yaml
└── README.md
```

---

## ⚙️ Instalación y ejecución

### 1) Requisitos previos

- Flutter SDK
- Python 3.10+
- MySQL Server (ej. XAMPP)
- Android Studio / Emulador Android o dispositivo físico

### 2) Backend (API)

```powershell
cd app_pedidos/API
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
```

Configura `API/.env` con tus credenciales de MySQL y una `JWT_SECRET_KEY`.

Levantar la API:

```powershell
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

- API: `http://127.0.0.1:8000`
- Docs Swagger: `http://127.0.0.1:8000/docs`

Al iniciar, la API crea automáticamente la BD `pedidos` (si no existe), tablas y datos de prueba.

### 3) App Flutter

```powershell
cd app_pedidos
flutter pub get
flutter run
```

> **Nota:** Por defecto la app usa `http://10.0.2.2:8000` para emulador Android.  
> Si usas dispositivo físico, cambia la URL en `lib/core/api_config.dart` por la IP LAN de tu PC.

---

## 🔑 Credenciales de prueba

- **Email:** `seed@pedidos.com`
- **Contraseña:** `seed12345`

---

## 🔌 Endpoints principales

### Auth
- `POST /auth/register` – Registro de usuario
- `POST /auth/login` – Inicio de sesión (devuelve JWT)

### Almuerzos *(requieren Bearer Token)*
- `GET /almuerzos` – Listar pedidos del usuario
- `GET /almuerzos/{id}` – Obtener pedido por ID
- `POST /almuerzos` – Crear pedido
- `PUT /almuerzos/{id}` – Actualizar / marcar entregado
- `DELETE /almuerzos/{id}` – Anular pedido

---

## 👥 Autores

- **Jorge Isaac Veliz Castañeda**
- **Juan Daniel Medina Garces**

---

## 📚 Contexto académico

Este proyecto fue elaborado como práctica para el curso:

> **Taller de Desarrollo de Aplicaciones Móviles**

Su objetivo es aplicar conceptos de desarrollo móvil, consumo de APIs REST, autenticación, persistencia, diseño de interfaces y trabajo con bases de datos.