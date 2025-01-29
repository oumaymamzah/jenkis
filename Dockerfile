# Stage 1: Build
# 1. Basez votre stage sur l'image node:12.7-alpine
FROM node:12.7-alpine AS build

# 2. Définir le répertoire de travail dans le conteneur
WORKDIR /usr/src/app

# 3. Copier les fichiers package.json et package-lock.json dans le répertoire de travail
COPY package*.json ./

# 4. Installer les dépendances du projet à partir du fichier package.json
RUN npm install

# 5. Copier tout le reste des fichiers du projet dans le conteneur
COPY . .

# 6. Exécuter la commande de build du projet Angular
RUN npm run build


# Stage 2: Run
# 1. Basez votre stage sur l'image nginx:1.17.1-alpine
FROM nginx:1.17.1-alpine

# 2. Copier le fichier de configuration nginx.conf dans le bon répertoire
COPY nginx.conf /etc/nginx/nginx.conf

# 3. Copier l'application compilée depuis le Stage 1 dans le répertoire de Nginx
COPY --from=build /usr/src/app/dist/aston-villa-app /usr/share/nginx/html

# 4. Exposer le port 80 pour le serveur Nginx
EXPOSE 80

# 5. Démarrer Nginx pour servir l'application Angular
CMD ["nginx", "-g", "daemon off;"]

