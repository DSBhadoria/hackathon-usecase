FROM node:18

COPY . .
WORKDIR /application-service/src

RUN npm init -y
RUN npm install

CMD ["node", "index.js"]
