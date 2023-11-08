# ---- Build ----
ARG DOCKERHUB_REPO=docker.internal.hysp.org
ARG NODEJS_VERSION=16.20
FROM ${DOCKERHUB_REPO}/code-js-base:${NODEJS_VERSION} as build

WORKDIR /app

# Install dependencies(add yarn.lock to have consisitent deps)
COPY ./package.json \
     ./yarn.lock \
     ./

RUN yarn install
COPY . .

RUN yarn build

# ---- Production ----
ARG DOCKERHUB_REPO=docker.internal.hysp.org
ARG NODEJS_VERSION=16.20
FROM ${DOCKERHUB_REPO}/code-js-base:${NODEJS_VERSION} AS production
WORKDIR /app

COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package*.json ./
# for i18 support
COPY --from=build /app/next.config.js ./next.config.js
COPY --from=build /app/next-i18next.config.js ./next-i18next.config.js

EXPOSE 3000
ENTRYPOINT [ "/bin/bash", "--login", "-c", "yarn start"]

