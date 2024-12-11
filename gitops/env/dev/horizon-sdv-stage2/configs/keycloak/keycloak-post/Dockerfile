FROM node:latest
WORKDIR /usr/src/app
RUN chown node:node ./
USER node
COPY package.json ./
COPY keycloak.mjs ./
RUN npm install
CMD ["node", "./keycloak.mjs"]
