# Official Alpine image | multistage build dev stage
FROM node:12.13-alpine As development

# Install dev dependencies
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=development
COPY . .

RUN npm run build

# Production stage
FROM node:12.13-alpine as production

# Set environment
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Install production dependencies
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production
COPY . .

# Copy built files into dist
COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/main"]