from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.db.database import Base, SessionLocal, engine, ensure_database_exists
from app.db.seed import seed_data
from app.routers import almuerzos, auth


@asynccontextmanager
async def lifespan(_: FastAPI):
    ensure_database_exists()
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        seed_data(db)
    finally:
        db.close()
    yield


app = FastAPI(
    title="Pedidos Almuerzos API",
    description="API REST para gestión de pedidos de almuerzos con autenticación JWT.",
    version="1.0.0",
    lifespan=lifespan,
)

app.include_router(auth.router)
app.include_router(almuerzos.router)


@app.get("/", tags=["health"])
def health():
    return {"status": "ok"}
