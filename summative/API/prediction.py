from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import pandas as pd
import numpy as np
import joblib
import os
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app with docs and OpenAPI schema
app = FastAPI(
    title="Crop Yield Prediction API",
    description="Predict crop yield (hg/ha) using a trained regression model.",
    version="1.0.0",
    docs_url="/docs",              # Swagger UI
    redoc_url="/redoc",            # Optional ReDoc UI
    openapi_url="/openapi.json"    # OpenAPI schema
)

# Enable CORS for testing and frontend connections
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all for dev; restrict in prod
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define expected input fields and order
FEATURE_NAMES = [
    "Item_Potatoes",
    "Area_United_Kingdom",
    "Item_Sweet_potatoes",
    "Area_Japan",
    "Year",
    "average_rain_fall_mm_per_year",
    "pesticides_tonnes",
    "avg_temp"
]

# Define input schema using Pydantic
class InputData(BaseModel):
    Item_Potatoes: int = Field(..., ge=0, le=1)
    Area_United_Kingdom: int = Field(..., ge=0, le=1)
    Item_Sweet_potatoes: int = Field(..., ge=0, le=1)
    Area_Japan: int = Field(..., ge=0, le=1)
    Year: int = Field(..., ge=1900, le=2100)
    average_rain_fall_mm_per_year: float = Field(..., ge=0)
    pesticides_tonnes: float = Field(..., ge=0)
    avg_temp: float

# Load trained model and scalers
MODEL_DIR = "models"

try:
    model = joblib.load(os.path.join(MODEL_DIR, "best_model.pkl"))
    x_scaler = joblib.load(os.path.join(MODEL_DIR, "scaler_X.pkl"))
    y_scaler = joblib.load(os.path.join(MODEL_DIR, "scaler_y.pkl"))
    logger.info("✅ Model and scalers loaded successfully.")
except Exception as e:
    logger.error(f"❌ Error loading model or scalers: {e}")
    raise RuntimeError(f"Failed to load model or scalers: {e}")

# Root endpoint
@app.get("/")
def root():
    return {"message": "🚀 Crop Yield Prediction API is live!"}

# Prediction endpoint
@app.post("/predict")
def predict(data: InputData):
    try:
        input_dict = data.dict()
        logger.debug(f"📥 Received input: {input_dict}")

        # Convert to DataFrame in correct order
        input_df = pd.DataFrame([input_dict], columns=FEATURE_NAMES)
        logger.debug(f"📊 Input DataFrame: \n{input_df}")

        # Preprocess input
        scaled_input = x_scaler.transform(input_df)

        # Predict and inverse scale
        scaled_pred = model.predict(scaled_input)
        prediction = y_scaler.inverse_transform(scaled_pred.reshape(-1, 1)).flatten()[0]

        logger.info(f"✅ Prediction successful: {prediction:.4f}")
        return {"predicted_crop_yield_hg_per_ha": round(float(prediction), 4)}

    except Exception as e:
        logger.error(f"❌ Prediction failed: {e}")
        raise HTTPException(status_code=400, detail=f"Bad input or processing error: {e}")
