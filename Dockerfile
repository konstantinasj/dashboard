# Build application artifacts
FROM node:12.13.1 AS builder

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build:frontend

# Deploy artifacts and run them in NGINX HTTP server
FROM nginx:1.17.10-alpine AS server

RUN mkdir -p /usr/share/nginx/dist

COPY --from=builder /usr/src/app/dist/en/ /usr/share/nginx/dist/
COPY nginx/nginx.conf /etc/nginx/nginx.conf

CMD nginx -g 'daemon off;'
