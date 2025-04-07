# main.py
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile
from fastapi.encoders import jsonable_encoder
from typing import Optional, List
from sqlalchemy.orm import Session
from sqlalchemy import text
import base64
from database import cad_get_db

router = APIRouter()

def encode_image(file: UploadFile) -> Optional[bytes]:
    """Converts an uploaded image to BYTEA format."""
    if file:
        return file.file.read()
    return None

def format_card_data(cards):
    """Convert binary images to Base64 for JSON response."""
    formatted_cards = []
    for card in cards:
        card_dict = dict(card)
        if card_dict.get("front_image"):
            card_dict["front_image"] = base64.b64encode(card_dict["front_image"]).decode("utf-8")
        if card_dict.get("back_image"):
            card_dict["back_image"] = base64.b64encode(card_dict["back_image"]).decode("utf-8")
        formatted_cards.append(card_dict)
    return formatted_cards

@router.post("/add_card/")
async def add_card(
    bank_name: str = Form(...),
    bank_code: Optional[str] = Form(None),
    card_type: str = Form(...),
    card_name: str = Form(...),
    card_network: str = Form(...),
    annual_fee: Optional[float] = Form(0.00),
    foreign_transaction_fee: Optional[float] = Form(0.00),
    rewards_program: Optional[str] = Form(None),
    petrol_benefits: Optional[str] = Form(None),
    network_pump: Optional[str] = Form(None),
    features: Optional[str] = Form(None),
    front_image_url: Optional[str] = Form(None),  # Changed to URL
    back_image_url: Optional[str] = Form(None),   # Changed to URL
    db: Session = Depends(cad_get_db),
):
    try:
        query = text("""
            INSERT INTO bank_cards 
            (bank_name, bank_code, card_type, card_name, card_network, 
            annual_fee, foreign_transaction_fee, rewards_program, 
            petrol_benefits, network_pump, features, front_image_url, back_image_url)
            VALUES (:bank_name, :bank_code, :card_type, :card_name, :card_network, 
                    :annual_fee, :foreign_transaction_fee, :rewards_program, 
                    :petrol_benefits, :network_pump, :features, :front_image_url, :back_image_url)
            RETURNING card_id;
        """)
        result = db.execute(query, {
            "bank_name": bank_name,
            "bank_code": bank_code,
            "card_type": card_type,
            "card_name": card_name,
            "card_network": card_network,
            "annual_fee": annual_fee,
            "foreign_transaction_fee": foreign_transaction_fee,
            "rewards_program": rewards_program,
            "petrol_benefits": petrol_benefits,
            "network_pump": network_pump,
            "features": features,
            "front_image_url": front_image_url,
            "back_image_url": back_image_url,
        })
        db.commit()
        card_id = result.scalar()
        return {"message": "Card added successfully", "card_id": card_id}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()

@router.patch("/update_card/{card_id}")
async def update_card(
    card_id: int,
    bank_name: Optional[str] = Form(None),
    bank_code: Optional[str] = Form(None),
    card_type: Optional[str] = Form(None),
    card_name: Optional[str] = Form(None),
    card_network: Optional[str] = Form(None),
    annual_fee: Optional[float] = Form(None),
    foreign_transaction_fee: Optional[float] = Form(None),
    rewards_program: Optional[str] = Form(None),
    petrol_benefits: Optional[str] = Form(None),
    network_pump: Optional[str] = Form(None),
    features: Optional[str] = Form(None),
    front_image: Optional[UploadFile] = File(None),
    back_image: Optional[UploadFile] = File(None),
    db: Session = Depends(cad_get_db),
):
    front_img_data = encode_image(front_image)
    back_img_data = encode_image(back_image)

    try:
        update_fields = []
        update_values = {"card_id": card_id}

        if bank_name: update_fields.append("bank_name = :bank_name"); update_values["bank_name"] = bank_name
        if bank_code: update_fields.append("bank_code = :bank_code"); update_values["bank_code"] = bank_code
        if card_type: update_fields.append("card_type = :card_type"); update_values["card_type"] = card_type
        if card_name: update_fields.append("card_name = :card_name"); update_values["card_name"] = card_name
        if card_network: update_fields.append("card_network = :card_network"); update_values["card_network"] = card_network
        if annual_fee is not None: update_fields.append("annual_fee = :annual_fee"); update_values["annual_fee"] = annual_fee
        if foreign_transaction_fee is not None: update_fields.append("foreign_transaction_fee = :foreign_transaction_fee"); update_values["foreign_transaction_fee"] = foreign_transaction_fee
        if rewards_program: update_fields.append("rewards_program = :rewards_program"); update_values["rewards_program"] = rewards_program
        if petrol_benefits: update_fields.append("petrol_benefits = :petrol_benefits"); update_values["petrol_benefits"] = petrol_benefits
        if network_pump: update_fields.append("network_pump = :network_pump"); update_values["network_pump"] = network_pump
        if features: update_fields.append("features = :features"); update_values["features"] = features
        if front_img_data: update_fields.append("front_image = :front_image"); update_values["front_image"] = front_img_data
        if back_img_data: update_fields.append("back_image = :back_image"); update_values["back_image"] = back_img_data

        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")

        update_query = text(f"UPDATE bank_cards SET {', '.join(update_fields)} WHERE card_id = :card_id RETURNING card_id")
        result = db.execute(update_query, update_values)
        db.commit()
        updated_card_id = result.scalar()
        if not updated_card_id:
            raise HTTPException(status_code=404, detail="Card not found")
        return {"message": "Card updated successfully", "card_id": updated_card_id}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()

@router.get("/get_all_cards/")
async def get_all_cards(db: Session = Depends(cad_get_db)):
    try:
        query = text("""
            SELECT card_id, bank_name, bank_code, card_type, card_name, card_network, 
                   annual_fee, foreign_transaction_fee, rewards_program, petrol_benefits, 
                   network_pump, features, front_image, back_image
            FROM bank_cards
        """)
        result = db.execute(query)
        cards = result.mappings().all()
        if not cards:
            raise HTTPException(status_code=404, detail="No cards found")
        return format_card_data(cards)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()

@router.get("/compare_cards/")
async def compare_cards(card_ids: str = Form(...), db: Session = Depends(cad_get_db)):
    try:
        card_id_list = [int(id.strip()) for id in card_ids.split(",")]
        query = text("""
            SELECT card_id, bank_name, bank_code, card_type, card_name, card_network, 
                   annual_fee, foreign_transaction_fee, rewards_program, petrol_benefits, 
                   network_pump, features, front_image, back_image
            FROM bank_cards
            WHERE card_id = ANY(:card_ids)
        """)
        result = db.execute(query, {"card_ids": card_id_list})
        cards = result.mappings().all()
        if not cards:
            raise HTTPException(status_code=404, detail="No cards found for the given IDs")
        return {"cards": format_card_data(cards)}
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid card_ids format. Use comma-separated integers.")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()

@router.get("/search/cards/")
async def search_cards(q: str, db: Session = Depends(cad_get_db)):
    try:
        query = text("""
            SELECT card_id, bank_name, bank_code, card_type, card_name, card_network, 
                   annual_fee, foreign_transaction_fee, rewards_program, petrol_benefits, 
                   network_pump, features, front_image, back_image
            FROM bank_cards
            WHERE card_name ILIKE :q 
               OR rewards_program ILIKE :q 
               OR features ILIKE :q 
               OR petrol_benefits ILIKE :q
        """)
        result = db.execute(query, {"q": f"%{q}%"})
        cards = result.mappings().all()
        if not cards:
            raise HTTPException(status_code=404, detail="No cards found matching the query")
        return {"results": format_card_data(cards)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()

@router.get("/banks/{bank_name}/cards/")
async def get_cards_by_bank(bank_name: str, db: Session = Depends(cad_get_db)):
    try:
        query = text("""
            SELECT card_id, bank_name, bank_code, card_type, card_name, card_network, 
                   annual_fee, foreign_transaction_fee, rewards_program, petrol_benefits, 
                   network_pump, features, front_image, back_image
            FROM bank_cards
            WHERE bank_name ILIKE :bank_name
        """)
        result = db.execute(query, {"bank_name": bank_name})
        cards = result.mappings().all()
        if not cards:
            raise HTTPException(status_code=404, detail=f"No cards found for bank: {bank_name}")
        return {"bank": bank_name, "cards": format_card_data(cards)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()

@router.get("/all_banks/")
async def get_all_banks(db: Session = Depends(cad_get_db)):
    """
    Retrieve a list of all unique bank names in the system.
    """
    try:
        query = text("""
            SELECT DISTINCT bank_name
            FROM bank_cards
            ORDER BY bank_name ASC
        """)
        result = db.execute(query)
        banks = result.mappings().all()
        if not banks:
            raise HTTPException(status_code=404, detail="No banks found")
        return {"banks": [bank["bank_name"] for bank in banks]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()

@router.get("/search/products/")
async def search_cards_by_product(product: str, db: Session = Depends(cad_get_db)):
    try:
        query = text("""
            SELECT bc.card_id, bc.bank_name, bc.card_type, bc.card_name, bc.card_network, 
                   bc.annual_fee, bc.rewards_program, pbc.offer_description
            FROM bank_cards bc
            JOIN products_bank_cards pbc ON bc.card_id = pbc.card_id
            JOIN products p ON pbc.product_id = p.product_id
            WHERE p.product_name ILIKE :product
        """)
        result = db.execute(query, {"product": f"%{product}%"})
        cards = result.mappings().all()
        if not cards:
            raise HTTPException(status_code=404, detail=f"No cards found for product: {product}")
        return {"product": product, "cards": [dict(card) for card in cards]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.close()

from fastapi import FastAPI
app = FastAPI()
app.include_router(router)
