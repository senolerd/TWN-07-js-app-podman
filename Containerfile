FROM node:20-alpine
WORKDIR /app
COPY app .
RUN npm install && npm audit fix
EXPOSE 3000
CMD ["npm", "start"]