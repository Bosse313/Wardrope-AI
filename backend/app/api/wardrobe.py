from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import WardrobeItem
from app.schemas import WardrobeItemCreate, WardrobeItemResponse

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/items", response_model=list[WardrobeItemResponse])
async def get_items(db: Session = Depends(get_db)):
    items = db.query(WardrobeItem).all()
    result = []
    for item in items:
        result.append(
            WardrobeItemResponse(
                id=item.id,
                name=item.name,
                category=item.category,
                subtype=item.subtype,
                image_url=item.image_url,
                color=item.color,
                pattern=item.pattern,
                material=item.material,
                season=item.season,
                style=item.style,
                size=item.size,
                favorite=item.favorite,
                status=item.status,
                last_worn_at=item.last_worn_at,
                created_at=item.created_at,
            )
        )
    return result


@router.post("/items", response_model=WardrobeItemResponse)
async def create_item(payload: WardrobeItemCreate, db: Session = Depends(get_db)):
    item = WardrobeItem(
        name=payload.name,
        category=payload.category,
        subtype=payload.subtype,
        image_url=payload.image_url,
        color=payload.color,
        pattern=payload.pattern,
        material=payload.material,
        season=payload.season,
        style=payload.style,
        size=payload.size,
        favorite=payload.favorite,
        status=payload.status,
    )

    db.add(item)
    db.commit()
    db.refresh(item)

    return WardrobeItemResponse(
        id=item.id,
        name=item.name,
        category=item.category,
        subtype=item.subtype,
        image_url=item.image_url,
        color=item.color,
        pattern=item.pattern,
        material=item.material,
        season=item.season,
        style=item.style,
        size=item.size,
        favorite=item.favorite,
        status=item.status,
        last_worn_at=item.last_worn_at,
        created_at=item.created_at,
    )


@router.patch("/items/{item_id}")
async def update_item(item_id: int, payload: WardrobeItemCreate, db: Session = Depends(get_db)):
    item = db.query(WardrobeItem).filter(WardrobeItem.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")

    for field, value in payload.model_dump().items():
        setattr(item, field, value)

    db.commit()
    return {"message": "Item updated"}


@router.post("/items/{item_id}/status")
async def set_status(item_id: int, status: str, db: Session = Depends(get_db)):
    item = db.query(WardrobeItem).filter(WardrobeItem.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")

    item.status = status
    db.commit()
    return {"message": f"Status set to {status}"}
