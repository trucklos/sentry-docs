FROM node:12-buster as build

ARG BUILD_CONF={}
ENV BUILD_CONF="$BUILD_CONF"

ARG ALGOLIA_INDEX=
ENV ALGOLIA_INDEX=$ALGOLIA_INDEX

ARG ALGOLIA_ADMIN_KEY=
ENV ALGOLIA_ADMIN_KEY=$ALGOLIA_ADMIN_KEY

ENV NODE_ENV=production

WORKDIR /app

RUN yarn global add gatsby-cli
ADD . ./
RUN yarn
RUN gatsby build

FROM gatsbyjs/gatsby

# https://github.com/gatsbyjs/gatsby-docker/blob/master/nginx-boot.sh

COPY --from=build /app/nginx.conf /etc/nginx/server.conf
COPY --from=build /app/public /pub
