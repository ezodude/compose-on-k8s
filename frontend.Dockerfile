FROM node:9-alpine

RUN apk --no-cache add curl

ENV PORT=8080
EXPOSE ${PORT}
WORKDIR /app

COPY ui/ /app/
RUN npm install

CMD ["npm", "start"]