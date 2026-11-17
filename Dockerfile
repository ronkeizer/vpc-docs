FROM node:10-buster-slim
RUN npm install -g gitbook-cli@2.3.2 && gitbook fetch 3.2.3
WORKDIR /book
