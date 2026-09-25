from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import Base, engine
from app.api import wardrobe, outfits, laundry

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Wardrobe AI")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(wardrobe.router, prefix="/wardrobe", tags=["wardrobe"])
app.include_router(outfits.router, prefix="/outfits", tags=["outfits"])
app.include_router(laundry.router, prefix="/laundry", tags=["laundry"])


@app.get("/")
async def root():
    return {"message": "Wardrobe AI API is running"}
