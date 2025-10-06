FROM node:18-alpine as base

# Install git for dependencies that may need it
RUN apk add --no-cache git

WORKDIR /app

# Copy package files
COPY package.json yarn.lock* package-lock.json* ./

# Install dependencies
RUN if [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
    elif [ -f package-lock.json ]; then npm ci; \
    else npm install; fi

# Copy application source
COPY . .

# Create non-root user
RUN addgroup -g 1000 node-app && \
    adduser -D -u 1000 -G node-app node-app && \
    chown -R node-app:node-app /app

USER node-app

# Expose port (not used for this function but good practice)
EXPOSE 3000

# Start the application
CMD ["node", "serviceCallbackFunction/index.js"]