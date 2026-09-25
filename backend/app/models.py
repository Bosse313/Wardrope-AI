from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    name = Column(String, nullable=False)
    preferred_style = Column(String, default="casual")
    created_at = Column(DateTime, default=datetime.utcnow)


class WardrobeItem(Base):
    __tablename__ = "wardrobe_items"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    name = Column(String, nullable=False)
    category = Column(String, nullable=False)
    subtype = Column(String, default="general")
    image_url = Column(String, nullable=True)
    color = Column(String, default="unknown")
    pattern = Column(String, default="solid")
    material = Column(String, default="unknown")
    season = Column(String, default="all")
    style = Column(String, default="casual")
    size = Column(String, default="m")
    favorite = Column(Boolean, default=False)
    status = Column(String, default="clean")
    last_worn_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    user = relationship("User")


class Outfit(Base):
    __tablename__ = "outfits"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    name = Column(String, default="Outfit")
    occasion = Column(String, default="daily")
    season = Column(String, default="all")
    style = Column(String, default="casual")
    favorite = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)


class OutfitItem(Base):
    __tablename__ = "outfit_items"

    id = Column(Integer, primary_key=True, index=True)
    outfit_id = Column(Integer, ForeignKey("outfits.id"))
    item_id = Column(Integer, ForeignKey("wardrobe_items.id"))
    position = Column(String, default="top")


class LaundryHistory(Base):
    __tablename__ = "laundry_history"

    id = Column(Integer, primary_key=True, index=True)
    item_id = Column(Integer, ForeignKey("wardrobe_items.id"))
    from_status = Column(String)
    to_status = Column(String)
    changed_at = Column(DateTime, default=datetime.utcnow)
