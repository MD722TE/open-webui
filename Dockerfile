FROM python:3.10-slim

# Variables d'environnement pour éviter le buffering et améliorer logs
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copier uniquement le fichier requirements.txt en premier pour profiter du cache Docker
COPY requirements.txt .

# Installer dépendances sans cache pip et sans build inutile
RUN pip install --no-cache-dir -r requirements.txt

# Copier le reste du code
COPY . .

# Commande pour lancer l'application (adaptable selon ton app)
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
