FROM node:20-alpine as builder

WORKDIR /app/medusa

RUN apk add python3 py3-pip pythonispython3

COPY package.json yarn.lock ./

RUN corepack enable && corepack prepare yarn@3.2.3
RUN yarn install

COPY . .

RUN yarn build

FROM node:20-alpine as production

WORKDIR /app/medusa

COPY --from=builder /app/medusa/.medusa/server .
COPY --from=builder /app/medusa/node_modules ./node_modules

CMD yarn start
