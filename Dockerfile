#Separate the process in different phases that we tag with specific names
#the tag is done with the "as" keyword
FROM node:alpine as builder 

WORKDIR '/app'

COPY package.json .
RUN npm install
#No need for volumes because in production environment we don't make immediate changes
COPY . .

#This means all the important files will be created in /app/build in the container
RUN npm run build


#No need to tag, automatically understands we're starting another phase 
FROM nginx

#Port mapping for AWS
EXPOSE 80

#Need to copy the build folder from previous phase
COPY --from=builder /app/build /usr/share/nginx/html