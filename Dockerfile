FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Lance le Typer CLI et sa commande `serve`, qui appellera Uvicorn avec app = open_webui.main:app
CMD ["python", "-m", "open_webui", "serve"]
