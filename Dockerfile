# Étape 1 : Build frontend
FROM node:20-alpine AS frontend
WORKDIR /app/webui
COPY webui/ .
RUN npm ci && npm run build

# Étape 2 : Backend Python minimal
FROM python:3.11-slim AS backend

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Dépendances système réduites
RUN apt-get update && apt-get install -y --no-install-recommends \
    libffi-dev build-essential \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY backend/ ./backend
COPY --from=frontend /app/webui/dist ./webui/dist

# Installe les dépendances Python (nettoie le reste)
RUN pip install --no-cache-dir -r backend/requirements.txt

CMD ["python", "-m", "backend.app"]
