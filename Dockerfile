# Étape 1 : Build allégé dans python:slim
FROM python:3.11-slim AS builder

# Dépendances système minimales
RUN apt-get update && apt-get install -y \
    gcc build-essential libffi-dev libsndfile1 \
    libgl1 libglib2.0-0 libsm6 libxext6 libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Créer l'environnement d'installation
WORKDIR /app
COPY requirements.txt .

# Utilisation de pip cache pour accélérer les builds
RUN pip install --upgrade pip \
 && pip install --prefix=/install --no-cache-dir -r requirements.prod.txt

# Étape 2 : Image finale ultra légère
FROM python:3.11-slim

# Dépendances runtime minimales (ex: soundfile, opencv, whisper)
RUN apt-get update && apt-get install -y \
    libsndfile1 libgl1 libglib2.0-0 libsm6 libxext6 libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Copie des dépendances installées
COPY --from=builder /install /usr/local

WORKDIR /app
COPY . .

# Exposition port FastAPI
EXPOSE 8000

# Commande de démarrage (modifiable si vous utilisez Gunicorn)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
