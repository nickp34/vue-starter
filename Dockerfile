FROM node:10-alpine AS builder

WORKDIR /app

# Install dependencies
COPY . .
RUN rm -rf node_modules
RUN yarn install
RUN yarn cache clean

RUN yarn run build

# ---

# runner container
#  - nginx, to serve static built Vue app

# Use an official nginx image
FROM nginx:1.15-alpine

# COPY dist from builder container to nginx html dir
COPY --from=builder /app/dist /usr/share/nginx/html

RUN rm -rf /etc/nginx/conf.d
RUN rm -f /etc/nginx/fast*
RUN rm -f /etc/nginx/scg*
RUN rm -f /etc/nginx/uwsgi*
RUN rm -f /etc/nginx/nginx.conf*
RUN rm -f /etc/nginx/win-*
RUN rm -f /etc/nginx/win-*

#Permissions needed for Openshift
RUN chgrp -R 0 /var/run /var/log/nginx
RUN chmod -R g=u /var/run /var/log/nginx

ENTRYPOINT ["nginx", "-c", "/tmp/nginx.conf", "-g", "daemon off;"]
