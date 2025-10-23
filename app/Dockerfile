
FROM node:18-alpine AS builder

WORKDIR /app
COPY src/package*.json ./
RUN npm ci
COPY . .
RUN npm run build || echo "Nenhum passo de build necessário"


FROM node:18-alpine

WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app /app
COPY healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh


RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup
USER nodeuser

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
  CMD /usr/local/bin/healthcheck.sh

CMD ["npm", "start"]