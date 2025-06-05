# Étape 1 : Build du frontend
FROM node:20-alpine AS frontend-builder
WORKDIR /app/webui
COPY webui/package*.json ./
RUN npm ci
COPY webui/ .
RUN npm run build

# Étape 2 : Build du backend minimal
FROM python:3.11-slim AS final
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Installe juste ce qui est nécessaire
RUN apt-get update && apt-get install -y --no-install-recommends \
    libffi-dev build-essential curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copie uniquement le backend utile
COPY backend/ ./backend/
COPY --from=frontend-builder /app/webui/dist ./webui/dist/

# Installe les deps Python sans cache
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 3000
CMD ["python", "-m", "backend.app"]
