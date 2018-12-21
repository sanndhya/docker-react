# NOTE: Dockerfile for Production
# base image with "as"
FROM node:alpine as builder

# define working directory
WORKDIR '/app'

# install dependecies
COPY package.json .
RUN npm install

# NOTE: due to "create-react-app projectname" command, it has automatically installed all the dependencies (node_module folder). 
# previously we never defined dependencies inside our project, but we used docker to install it when initially the image is created. 
# So we have duplicate dependencies, which is not reliable. We will delete that extra folder(node_modules).
COPY . .

# run command
RUN npm run build

# We are adding another Base Image here.
# Nginx server
FROM nginx

# in the output of "npm run build" will be inside of /app/build folder inside container.
# so we are copying it. because we only need (build folder ) for "npm run"
# the syntext can be found in Nginx docker hub.
COPY --from=builder /app/build /usr/share/nginx/html
