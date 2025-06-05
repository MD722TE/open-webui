# Étape 1 : build (optionnelle si tu n'as pas de build à faire)
FROM python:3.10-slim AS base

# Empêche Python de créer des fichiers .pyc
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Dépendances système nécessaires (ajuste si besoin)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crée le dossier de l’app
WORKDIR /app

# Copie les dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Installation des dépendances
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copie tout le code source
COPY . .

# S’assure que backend/ et open_webui/ sont bien des packages
RUN touch backend/__init__.py && touch backend/open_webui/__init__.py

# Commande par défaut
CMD ["uvicorn", "backend.open_webui.main:app", "--host", "0.0.0.0", "--port", "8000"]
