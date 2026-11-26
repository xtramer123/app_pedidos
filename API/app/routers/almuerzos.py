from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy.orm import Session

from app.db.database import get_db
from app.dependencies.auth import get_current_user
from app.models.almuerzo import Almuerzo
from app.models.usuario import Usuario
from app.schemas.almuerzo import AlmuerzoCreate, AlmuerzoResponse, AlmuerzoUpdate

router = APIRouter(prefix="/almuerzos", tags=["almuerzos"])


def _get_owned_almuerzo(almuerzo_id: int, db: Session, current_user: Usuario) -> Almuerzo:
    almuerzo = (
        db.query(Almuerzo)
        .filter(Almuerzo.id == almuerzo_id, Almuerzo.usuario_id == current_user.id)
        .first()
    )
    if not almuerzo:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Almuerzo no encontrado")
    return almuerzo


@router.get("", response_model=list[AlmuerzoResponse])
def list_almuerzos(db: Session = Depends(get_db), current_user: Usuario = Depends(get_current_user)):
    return (
        db.query(Almuerzo)
        .filter(Almuerzo.usuario_id == current_user.id)
        .order_by(Almuerzo.id.desc())
        .all()
    )


@router.get("/{almuerzo_id}", response_model=AlmuerzoResponse)
def get_almuerzo(almuerzo_id: int, db: Session = Depends(get_db), current_user: Usuario = Depends(get_current_user)):
    return _get_owned_almuerzo(almuerzo_id, db, current_user)


@router.post("", response_model=AlmuerzoResponse, status_code=status.HTTP_201_CREATED)
def create_almuerzo(
    payload: AlmuerzoCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    almuerzo = Almuerzo(
        cliente=payload.cliente.strip(),
        plato=payload.plato.strip(),
        cantidad=payload.cantidad,
        precio=payload.precio,
        fecha_pedido=date.today(),
        entregado=False,
        usuario_id=current_user.id,
    )
    db.add(almuerzo)
    db.commit()
    db.refresh(almuerzo)
    return almuerzo


@router.put("/{almuerzo_id}", response_model=AlmuerzoResponse)
def update_almuerzo(
    almuerzo_id: int,
    payload: AlmuerzoUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    almuerzo = _get_owned_almuerzo(almuerzo_id, db, current_user)
    data = payload.model_dump(exclude_unset=True)
    if not data:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="No se enviaron campos para actualizar")

    for field, value in data.items():
        if isinstance(value, str):
            value = value.strip()
        setattr(almuerzo, field, value)

    db.commit()
    db.refresh(almuerzo)
    return almuerzo


@router.delete("/{almuerzo_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_almuerzo(
    almuerzo_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(get_current_user),
):
    almuerzo = _get_owned_almuerzo(almuerzo_id, db, current_user)
    db.delete(almuerzo)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)
