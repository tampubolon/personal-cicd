# Use an official Node.js runtime as a parent image
FROM node:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all the application code to the working directory
COPY . .

# Expose the port on which your application runs
EXPOSE 8080

# Define the command to run your application
CMD ["node", "app.js"]