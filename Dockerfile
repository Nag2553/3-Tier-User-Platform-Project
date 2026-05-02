FROM node:20-alpine

# ---- CLIENT BUILD ----
WORKDIR /usr/src/app/client
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build

# ---- SERVER SETUP ----
WORKDIR /usr/src/app/server
COPY server/package*.json ./
RUN npm install --omit=dev
COPY server/ ./

# Copy client build/public to server
RUN mkdir -p ./public && cp -R /usr/src/app/client/public/* ./public/

ENV NODE_ENV=production

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Fix ownership
RUN chown -R appuser:appgroup /usr/src/app

USER appuser

EXPOSE 5000

CMD ["npm", "start"]
