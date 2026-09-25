from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class UserCreate(BaseModel):
    email: str
    name: str
    preferred_style: Optional[str] = "casual"


class UserResponse(UserCreate):
    id: int
    created_at: datetime


class WardrobeItemCreate(BaseModel):
    name: str
    category: str
    subtype: Optional[str] = "general"
    image_url: Optional[str] = None
    color: Optional[str] = "unknown"
    pattern: Optional[str] = "solid"
    material: Optional[str] = "unknown"
    season: Optional[str] = "all"
    style: Optional[str] = "casual"
    size: Optional[str] = "m"
    favorite: bool = False
    status: str = "clean"


class WardrobeItemResponse(WardrobeItemCreate):
    id: int
    last_worn_at: Optional[datetime] = None
    created_at: datetime


class OutfitGenerateRequest(BaseModel):
    occasion: Optional[str] = "daily"
    season: Optional[str] = "all"
    style: Optional[str] = "casual"


class OutfitSuggestion(BaseModel):
    title: str
    item_ids: List[int]
    score: float
    reason: str
