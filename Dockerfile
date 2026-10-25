#
# Base & Dependencies
#
FROM node:24.22.1-alpine AS base

WORKDIR /usr/src/cens

COPY package*.json ./


#
# Development Environment
#
FROM base AS development

# Default to local dev, but CID image can be built with: docker build --target development --build-arg INSTALL_COMMAND=ci .
ARG INSTALL_COMMAND=install

RUN if [ "$INSTALL_COMMAND" = "ci" ]; then \
        npm ci; \
    else \
        npm install; \
    fi

COPY . .
COPY ./.env-example ./.env

EXPOSE 8080

CMD [ "npm", "run", "dev" ]


#
# Production Runtime
#
FROM base AS production

ENV NODE_ENV=production

RUN npm ci --only=production

COPY . .

USER node

EXPOSE 8080

CMD [ "node", "server.js" ]

