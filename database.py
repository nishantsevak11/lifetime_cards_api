# database.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
DATABASE_URL = ""

# card_engine = create_engine("")

print(f"Connecting to: {DATABASE_URL}")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def cad_get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()