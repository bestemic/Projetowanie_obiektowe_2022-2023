FROM node:18.16.0

RUN mkdir frontend
WORKDIR frontend

COPY . .

RUN npm ci --ignore-scripts

RUN chown -R node:node /frontend
RUN chmod -R 755 /frontend

USER node

EXPOSE 5173

CMD ["npm", "run", "dev"]