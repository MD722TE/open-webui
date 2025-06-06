FROM python:3.10-slim

WORKDIR /app

# Copie des fichiers nécessaires
COPY backend/ ./backend/

# Déclaration du PYTHONPATH
ENV PYTHONPATH="/app/backend:${PYTHONPATH}"

# Installation des dépendances
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Lancement de l'app
CMD ["uvicorn", "open_webui.main:app", "--host", "0.0.0.0", "--port", "8080"]
