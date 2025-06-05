# Étape 1 : build dans une image légère
FROM python:3.10-slim as builder

WORKDIR /app

# Installer uniquement les outils nécessaires pour l'installation des paquets
RUN apt-get update && apt-get install -y gcc build-essential libffi-dev && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip && pip install --prefix=/install -r requirements.txt

# Étape 2 : Image finale ultra-légère
FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

# Lancer l'application
CMD ["uvicorn", "backend.open_webui.main:app", "--host", "0.0.0.0", "--port", "8080"]
