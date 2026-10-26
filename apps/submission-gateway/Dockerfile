# Stage 1: Build environment
FROM node:20-alpine AS builder

WORKDIR /app

# Copy root workspace and package configuration files
COPY package.json ./
COPY apps/submission-gateway/package.json ./apps/submission-gateway/

# Install all workspace dependencies
RUN npm install

# Copy submission gateway source code
COPY apps/submission-gateway ./apps/submission-gateway

# Compile TypeScript
WORKDIR /app/apps/submission-gateway
RUN npm run build

# Stage 2: Production runtime image
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8080

# Copy node modules and built application artifacts from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/apps/submission-gateway/dist ./apps/submission-gateway/dist
COPY --from=builder /app/apps/submission-gateway/package.json ./apps/submission-gateway/package.json

EXPOSE 8080

# Run the compiled gateway service
CMD ["node", "apps/submission-gateway/dist/index.js"]
