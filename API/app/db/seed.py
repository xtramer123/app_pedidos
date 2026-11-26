from datetime import date
from decimal import Decimal

from sqlalchemy.orm import Session

from app.core.security import hash_password
from app.models.almuerzo import Almuerzo
from app.models.usuario import Usuario

SEED_USER_EMAIL = "seed@pedidos.com"


def seed_data(db: Session) -> None:
    seed_user = db.query(Usuario).filter(Usuario.email == SEED_USER_EMAIL).first()
    if seed_user is None:
        seed_user = Usuario(
            nombre="Usuario Seed",
            email=SEED_USER_EMAIL,
            password=hash_password("seed12345"),
            rol="USER",
        )
        db.add(seed_user)
        db.commit()
        db.refresh(seed_user)

    existing_count = db.query(Almuerzo).filter(Almuerzo.usuario_id == seed_user.id).count()
    if existing_count >= 5:
        return

    samples = [
        Almuerzo(
            cliente="Carlos Pérez",
            plato="Arroz con pato",
            cantidad=2,
            precio=Decimal("18.50"),
            fecha_pedido=date.today(),
            entregado=False,
            usuario_id=seed_user.id,
        ),
        Almuerzo(
            cliente="María Torres",
            plato="Seco de cabrito",
            cantidad=1,
            precio=Decimal("22.00"),
            fecha_pedido=date.today(),
            entregado=False,
            usuario_id=seed_user.id,
        ),
        Almuerzo(
            cliente="José Ramírez",
            plato="Ceviche norteño",
            cantidad=3,
            precio=Decimal("20.00"),
            fecha_pedido=date.today(),
            entregado=True,
            usuario_id=seed_user.id,
        ),
        Almuerzo(
            cliente="Ana Castillo",
            plato="Shambar",
            cantidad=2,
            precio=Decimal("15.00"),
            fecha_pedido=date.today(),
            entregado=False,
            usuario_id=seed_user.id,
        ),
        Almuerzo(
            cliente="Luis Fernández",
            plato="King Kong de manjarblanco",
            cantidad=1,
            precio=Decimal("12.50"),
            fecha_pedido=date.today(),
            entregado=False,
            usuario_id=seed_user.id,
        ),
    ]

    for item in samples[existing_count:5]:
        db.add(item)
    db.commit()
