FROM mhart/alpine-node:12.18.3 AS build

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache --upgrade git

WORKDIR /codepan

RUN npm install -g yarn --registry=https://registry.npm.taobao.org/

COPY ./package.json ./

RUN yarn --registry=https://registry.npm.taobao.org/

COPY ./static ./static
COPY ./poi.config.js ./index.ejs ./
COPY ./src ./src
COPY .git ./.git

RUN yarn build

FROM nginx:1.18.0-alpine

COPY --from=build /codepan/dist/ /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
