# API Endpoints Documentation

## Endpoints Overview

- `POST /add_card/` - Add a new bank card
- `PATCH /update_card/{card_id}` - Update an existing card
- `GET /get_all_cards/` - Retrieve all cards
- `GET /compare_cards/` - Compare specific cards by IDs
- `GET /search/cards/` - Search cards by various attributes
- `GET /banks/{bank_name}/cards/` - Get all cards for a specific bank
- `GET /search/products/` - Search cards by product offers
- `GET /all_banks/` - Get list of all unique banks (new endpoint)

## Detailed Endpoint Documentation

### `POST /add_card/`
**Description:** Creates a new bank card entry  
**Request Body:** Form-data

```json
{
  "bank_name": "string (required)",
  "bank_code": "string (optional)",
  "card_type": "string (required, enum: debit/credit/prepaid)",
  "card_name": "string (required)",
  "card_network": "string (required, enum: visa/mastercard/plux/food)",
  "annual_fee": "float (optional, default: 0.00)",
  "foreign_transaction_fee": "float (optional, default: 0.00)",
  "rewards_program": "string (optional)",
  "petrol_benefits": "string (optional)",
  "network_pump": "string (optional)",
  "features": "string (optional)",
  "front_image": "file (optional, binary)",
  "back_image": "file (optional, binary)"
}

Success (200):

```json

{
  "message": "Card added successfully",
  "card_id": integer
}

Error (500):

{
  "detail": "error message"
}

GET /all_banks/
Description: Retrieves a list of all unique bank names
Parameters: None

Response:
Success (200):


{
  "banks": [
    "Chase",
    "American Express",
    ...
  ]
}
Error (404):


{
  "detail": "No banks found"
}
Error (500):

{
  "detail": "error message"
}
GET /banks/{bank_name}/cards/
Description: Retrieves all cards for a specific bank
Path Parameter:
bank_name: string (case-insensitive)

Response:
Success (200):

{
  "bank": "Chase",
  "cards": [
    {
      "card_id": 1,
      "bank_name": "Chase",
      "bank_code": "CHASE001",
      "card_type": "credit",
      "card_name": "Chase Sapphire",
      "card_network": "visa",
      "annual_fee": 95.00,
      "foreign_transaction_fee": 0.00,
      "rewards_program": "2x travel, 3x dining",
      "petrol_benefits": "5% off at Shell",
      "network_pump": null,
      "features": "Lounge access",
      "front_image": "base64_string",
      "back_image": "base64_string"
    },
    ...
  ]
}
Error (404):

{
  "detail": "No cards found for bank: Chase"
}
GET /get_all_cards/
Description: Retrieves all cards in the system
Response: Array of card objects (same structure as in /banks/{bank_name}/cards/)

Card Object Structure

{
  "card_id": integer,
  "bank_name": string,
  "bank_code": string|null,
  "card_type": string (debit/credit/prepaid),
  "card_name": string,
  "card_network": string (visa/mastercard/plux/food),
  "annual_fee": float,
  "foreign_transaction_fee": float,
  "rewards_program": string|null,
  "petrol_benefits": string|null,
  "network_pump": string|null,
  "features": string|null,
  "front_image": string (base64)|null,
  "back_image": string (base64)|null

