from datetime import date
from decimal import Decimal

from pydantic import BaseModel, ConfigDict, Field, computed_field


class AlmuerzoBase(BaseModel):
    cliente: str = Field(min_length=1, max_length=100)
    plato: str = Field(min_length=1, max_length=100)
    cantidad: int = Field(gt=0)
    precio: Decimal = Field(gt=0, max_digits=8, decimal_places=2)


class AlmuerzoCreate(AlmuerzoBase):
    pass


class AlmuerzoUpdate(BaseModel):
    cliente: str | None = Field(default=None, min_length=1, max_length=100)
    plato: str | None = Field(default=None, min_length=1, max_length=100)
    cantidad: int | None = Field(default=None, gt=0)
    precio: Decimal | None = Field(default=None, gt=0, max_digits=8, decimal_places=2)
    entregado: bool | None = None


class AlmuerzoResponse(AlmuerzoBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    fecha_pedido: date
    entregado: bool
    usuario_id: int

    @computed_field(return_type=Decimal)
    @property
    def total(self) -> Decimal:
        return (self.precio * self.cantidad).quantize(Decimal("0.01"))
