# Utiliser une image de base légère
FROM node:20-slim

# Créer un utilisateur non-root
RUN useradd -m openwebui

WORKDIR /home/openwebui

# Télécharger le code source depuis le dépôt
RUN apt-get update && apt-get install -y git && \
    git clone https://github.com/open-webui/open-webui.git . && \
    rm -rf .git

# Installer les dépendances
RUN npm install --omit=dev

# Supprimer Ollama et ses références
RUN rm -rf server/ollama* docker/ollama*

# Exposer le port
EXPOSE 3000

# Passer à l'utilisateur non-root
USER openwebui

# Lancer l'application
CMD ["npm", "run", "start"]
