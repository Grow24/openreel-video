FROM node:22-bookworm-slim AS build

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@11.7.0 --activate

COPY . .

ENV ELECTRON_SKIP_BINARY_DOWNLOAD=1
ENV CI=true

RUN pnpm install --frozen-lockfile
RUN pnpm build

FROM nginx:1.27-alpine

COPY deploy/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/apps/web/dist /usr/share/nginx/html

EXPOSE 8080
