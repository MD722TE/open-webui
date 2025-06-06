# syntax=docker/dockerfile:1

FROM python:3.11-slim

# Préparer les dépendances de build si nécessaires
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc build-essential libffi-dev libssl-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non root
RUN useradd -m -u 1000 appuser

# Définir le répertoire de travail
WORKDIR /app

# Copier uniquement les fichiers nécessaires à la prod
COPY backend/requirements.txt .

# Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copier le code backend
COPY backend/ .

# Passer à l'utilisateur non root
USER appuser

# Commande de démarrage
CMD ["python", "main.py"]
