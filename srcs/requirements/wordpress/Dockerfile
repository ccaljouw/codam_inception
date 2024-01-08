FROM alpine:3.18.5


RUN apt update -y 
RUN apt install php-fpm php-mysql -y
RUN apt install curl -y

COPY ./tools/installWP.sh /

CMD [ "/installWP.sh" ]