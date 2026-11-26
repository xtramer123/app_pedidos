from datetime import date
from decimal import Decimal

from sqlalchemy import BigInteger, Boolean, Date, ForeignKey, Integer, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class Almuerzo(Base):
    __tablename__ = "almuerzo"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    cliente: Mapped[str] = mapped_column(String(100), nullable=False)
    plato: Mapped[str] = mapped_column(String(100), nullable=False)
    cantidad: Mapped[int] = mapped_column(Integer, nullable=False)
    precio: Mapped[Decimal] = mapped_column(Numeric(8, 2), nullable=False)
    fecha_pedido: Mapped[date] = mapped_column(Date, nullable=False)
    entregado: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    usuario_id: Mapped[int] = mapped_column(BigInteger, ForeignKey("usuario.id"), nullable=False, index=True)

    usuario = relationship("Usuario", back_populates="almuerzos")
