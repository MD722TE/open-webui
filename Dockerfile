# Étape de build
FROM python:3.10-slim AS builder

# Répertoire de travail
WORKDIR /app

# Copie et installation des dépendances
COPY backend/requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Étape finale
FROM python:3.10-slim

WORKDIR /app

# Copie des fichiers
COPY --from=builder /root/.local /root/.local
COPY backend/ ./backend/

# Ajout du PYTHONPATH pour permettre les imports depuis /app/backend
ENV PYTHONPATH="/app/backend:${PYTHONPATH}"
ENV PATH="/root/.local/bin:${PATH}"

# Port par défaut pour Uvicorn
EXPOSE 8080

# Commande de lancement
CMD ["uvicorn", "open_webui.main:app", "--host", "0.0.0.0", "--port", "8080"]
