ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk add --no-cache jq nodejs nodejs-npm git
 
WORKDIR /data

RUN npm config set unsafe-perm true \
	&& npm install -g sky-remote-cli \
	&& npm config set unsafe-perm false

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]