from sqlalchemy import create_engine, text
from sqlalchemy.orm import DeclarativeBase, sessionmaker

from app.core.config import settings


class Base(DeclarativeBase):
    pass


def ensure_database_exists() -> None:
    if settings.database_url.startswith("postgresql"):
        return
    server_engine = create_engine(settings.server_url, isolation_level="AUTOCOMMIT", pool_pre_ping=True)
    try:
        with server_engine.connect() as conn:
            db_name = settings.db_name.replace("`", "``")
            conn.execute(text(f"CREATE DATABASE IF NOT EXISTS `{db_name}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"))
    finally:
        server_engine.dispose()


engine = create_engine(settings.database_url, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
