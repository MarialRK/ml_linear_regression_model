#  Crop Yield Prediction Project

This repository contains the complete Crop Yield Prediction Project, developed as part of a summative assignment. The project integrates machine learning model development, a FastAPI backend, and a Flutter mobile app to predict crop yields based on environmental and agricultural factors.

---

##  Project Overview

###  Task 1: Linear Regression Model Development

- Built and optimized ML models to predict crop yield using the [Crop Yield Prediction Dataset from Kaggle](https://www.kaggle.com/datasets/mrigaankjaswal/crop-yield-prediction-dataset/data).
- Performed data visualization, feature engineering, standardization, and model comparison.
- Compared **Linear Regression**, **Decision Tree**, and **Random Forest** models.
- Saved the best-performing model for deployment.
  - Google Colab Notebook: [Click to View Notebook](https://colab.research.google.com/drive/1Own6xUtHjDfxUMskFYlzuYtCwSIgC8I-?usp=sharing)

➡️ Detailed information and code are inside the [`linear_regression/`](summative/linear_regression) directory.

---

###  Task 2: FastAPI Backend

- Created a FastAPI-based REST API to serve the trained model for predictions.
- Input validation with **Pydantic**, added **CORS** middleware.
- POST endpoint `/predict` accepts JSON input for crop yield prediction.
- Deployed API on Render.

- 🧪 Try it on Swagger: [https://fastapi-rm5x.onrender.com/docs#/default/predict_predict__post](https://fastapi-rm5x.onrender.com/docs#/default/predict_predict__post)

 All source code is located in the [`API/`](summative/API) directory.

---

###  Task 3: Flutter Mobile App

- A multi-page Flutter app that interacts with the deployed FastAPI for real-time crop yield predictions.
- Users enter inputs like average rainfall, pesticide usage, and temperature.
- Uses HTTP POST to send values and display predictions or error messages.
- 🎨 Figma Design: [Open Figma Design](https://www.figma.com/design/MxoAOSFXKB7azCbUcSEhEW/Wildlife-Activity-Predictor?node-id=0-1&t=qZiQdCtCC99BJ7tF-1)

 Setup and full app code in the [`FlutterApp/`](summative/FlutterApp) directory.

---

###  Task 4: Video Demonstration

 **[Watch the Demo Video on YouTube](https://youtu.be/wexNGIi4QpQ)**  
Includes:
- Colab notebook and model training overview
- Swagger UI test
- Full Flutter app walkthrough using the deployed API

---

##  Dataset Overview

The dataset includes:

- `Area` (Country)
- `Item` (Crop)
- `Year`
- `hg/ha_yield` → **Target variable (crop yield)**
- `average_rain_fall_mm_per_year`
- `pesticides_tonnes`
- `avg_temp`

---

##  Technologies Used

| Component        | Tools / Libraries                               |
|------------------|--------------------------------------------------|
| ML + Data        | Python, scikit-learn, pandas, numpy              |
| API Backend      | FastAPI, Pydantic, Uvicorn, Render               |
| Mobile App       | Flutter, Dart, HTTP package                      |
| Miscellaneous    | MinMaxScaler, pickle, Swagger UI, Figma          |

---

##  Setup Instructions

### 🔧 Clone Repository

```bash
git clone https://github.com/MarialRK/ml_linear_regression_model
cd ml_linear_regression_model/summative
