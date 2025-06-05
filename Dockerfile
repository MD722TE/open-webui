# Étape 1 : build du frontend
FROM node:20-alpine AS build-ui
WORKDIR /app/webui
COPY webui/ .
RUN npm ci && npm run build

# Étape 2 : backend Python
FROM python:3.11-slim AS runtime

# Réduction de la taille : variables d'env, désactivation de pip cache, nettoyage
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Dépendances système minimales
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libffi-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copie du backend
COPY backend/ ./backend

# Installation des dépendances Python
RUN pip install --no-cache-dir -r backend/requirements.txt

# Copie des assets web compilés
COPY --from=build-ui /app/webui/dist ./webui/dist

# Commande de lancement
CMD ["python", "-m", "backend.app"]
