FROM node:22-alpine3.21

ARG USER_NAME=web
ARG ID=101
RUN addgroup -g $ID $USER_NAME && adduser -u $ID -h /home/$USER_NAME/ -D -G $USER_NAME $USER_NAME

WORKDIR /home/$USER_NAME/app

COPY package.json ./
COPY yarn.lock ./
COPY rescript.json ./
COPY src src/

RUN yarn install --frozen-lockfile && yarn run res:build && yarn cache clean

EXPOSE 8080

USER $USER_NAME

CMD ["node", "src/Main.res.mjs"]

