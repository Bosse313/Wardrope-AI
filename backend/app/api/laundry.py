from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import WardrobeItem

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/items")
async def get_laundry_items(db: Session = Depends(get_db)):
    items = db.query(WardrobeItem).filter(WardrobeItem.status == "in_wash").all()
    return [
        {
            "id": item.id,
            "name": item.name,
            "category": item.category,
            "status": item.status,
        }
        for item in items
    ]


@router.post("/items/{item_id}/clean")
async def mark_clean(item_id: int, db: Session = Depends(get_db)):
    item = db.query(WardrobeItem).filter(WardrobeItem.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")

    item.status = "clean"
    db.commit()
    return {"message": "Item is clean again and available for outfits"}
