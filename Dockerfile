FROM node:22-alpine3.21

WORKDIR /home/node/app

COPY package.json ./
COPY yarn.lock ./
COPY rescript.json ./
COPY src src/

RUN yarn install --frozen-lockfile && yarn run res:build && yarn cache clean

EXPOSE 8080

USER node

CMD ["node", "src/Main.res.mjs"]

