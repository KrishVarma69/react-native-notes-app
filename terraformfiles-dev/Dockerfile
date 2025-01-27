# Use an official Node.js runtime as a parent image
FROM node:16

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN sudo apt update && sudo apt upgrade -y && sudo apt install -y nodejs npm

# Copy the rest of the application files
COPY . .

# Expose the application port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]


# Below are the commands to execute the docker file to build an image and a container
# docker build -t react-native-app .
# docker run -d -p 80:3000 react-native-app
