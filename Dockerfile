FROM node:18-alpine as base

# Install git for dependencies that may need it
RUN apk add --no-cache git

WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies using npm (skips local file dependencies issues)
RUN npm install --omit=dev --ignore-scripts || npm install --omit=dev

# Copy application source
COPY . .

# Use existing node user from base image
RUN chown -R node:node /app

USER node

# Expose port (not used for this function but good practice)
EXPOSE 3000

# Start the application
CMD ["node", "serviceCallbackFunction/index.js"]