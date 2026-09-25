from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import WardrobeItem
from app.schemas import OutfitGenerateRequest, OutfitSuggestion

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/generate", response_model=list[OutfitSuggestion])
async def generate_outfits(request: OutfitGenerateRequest, db: Session = Depends(get_db)):
    items = db.query(WardrobeItem).filter(WardrobeItem.status == "clean").all()

    tops = [i for i in items if i.category in ["T-Shirt", "Polo", "Hemd"]]
    bottoms = [i for i in items if i.category in ["Hose", "Jeans"]]
    shoes = [i for i in items if i.category in ["Schuhe", "Sneaker"]]
    jackets = [i for i in items if i.category in ["Jacke", "Pullover"]]

    if not tops or not bottoms or not shoes:
        return []

    suggestions = []

    for idx in range(min(3, len(tops), len(bottoms), len(shoes))):
        top = tops[idx % len(tops)]
        bottom = bottoms[(idx + 1) % len(bottoms)]
        shoe = shoes[(idx + 2) % len(shoes)]
        jacket = jackets[idx % len(jackets)] if jackets else None

        item_ids = [top.id, bottom.id, shoe.id]
        if jacket:
            item_ids.append(jacket.id)

        score = round(0.84 + idx * 0.05, 2)

        reason = (
            "Die Kombination ist passend, modern und für den Alltag sehr praktisch."
            if idx % 2 == 0
            else "Die Farben und das Stilgefühl ergänzen sich gut und wirken sehr sauber."
        )

        suggestions.append(
            OutfitSuggestion(
                title=["Casual Daily Look", "Smart Casual", "Weekend Style"][idx],
                item_ids=item_ids,
                score=score,
                reason=reason,
            )
        )

    return suggestions
