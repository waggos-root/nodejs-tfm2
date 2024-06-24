FROM node:18-alpine
ENV WORKDIR /usr/src/app/
WORKDIR $WORKDIR
COPY package*.json $WORKDIR
RUN npm install --production --no-cache

FROM node:18-alpine
ENV USER node
ENV WORKDIR /home/$USER/app
WORKDIR $WORKDIR
COPY --from=0 /usr/src/app/node_modules node_modules
COPY --from=0 /usr/src/app/package-lock.json package-lock.json
COPY  . "$WORKDIR"
# --chown=node --chmod=755
RUN chown "$USER":"$USER" "$WORKDIR"
RUN chown -R "$USER":"$USER" /home/"$USER" && chmod -R g-s,o-rx /home/"$USER" && chmod -R o-wrx "$WORKDIR"
USER $USER
EXPOSE 4000
