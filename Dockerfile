ARG DOCKERHUB_REPO=docker.internal.hysp.org
ARG NODEJS_VERSION=16.20
FROM ${DOCKERHUB_REPO}/code-js-base:${NODEJS_VERSION}

WORKDIR /app/js/projects/chatbot-ui

# Install dependencies
COPY js/package.json \
     js/tsconfig.json \
     js/yarn.lock \
     /app/js/
COPY js/makefiles /app/js/makefiles/
COPY js/projects/chatbot-ui/package-lock.json \
     js/projects/chatbot-ui/package.json \
     js/projects/chatbot-ui/yarn.lock \
     js/projects/chatbot-ui/next.config.js \
     js/projects/chatbot-ui/next-i18next.config.js \
     /app/js/projects/chatbot-ui/

RUN yarn install

COPY js/projects/chatbot-ui ./

RUN yarn build

EXPOSE 3000
ENTRYPOINT [ "/bin/bash", "--login", "-c"]
