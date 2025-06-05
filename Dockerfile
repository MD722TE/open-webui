FROM python:3.10-slim

# Variables d'environnement pour éviter les questions interactives
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copier requirements.txt et installer les dépendances
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copier tout le code
COPY . /app

# Exposer le port 8080 (par convention)
EXPOSE 8080

# Commande de démarrage (lire le PORT env var via uvicorn)
CMD ["uvicorn", "open_webui.main:app", "--host", "0.0.0.0", "--port", "8080"]
