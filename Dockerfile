FROM node:22-alpine3.21

WORKDIR /app

COPY package.json /app
COPY yarn.lock /app
RUN yarn install --frozen-lockfile

COPY . /app
RUN yarn run res:build

EXPOSE 8080

CMD ["node", "src/Main.res.mjs"]

