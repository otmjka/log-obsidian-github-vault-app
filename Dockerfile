FROM node:20-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]

# # Use the official Node.js image from the Docker Hub
# FROM node:20-alpine as build

# # Set the working directory
# WORKDIR /app

# # Copy package.json and package-lock.json for dependency installation
# COPY package*.json .

# # Install production dependencies only
# RUN npm install

# # Copy application source code
# COPY . .

# RUN npm run build

# #Production stage
# FROM node:20-alpine AS production

# WORKDIR /app

# COPY package*.json .

# RUN npm ci --only=production

# COPY --from=build /app/dist ./dist

# CMD ["node", "dist/index.js"]