FROM golang:1.7.5

ENV DOCKER_VERSION 1.12.5

# download minecraft server
WORKDIR /srv
RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh)" && mv Server cuberite_server
RUN ln -s /srv/cuberite_server/Cuberite /usr/bin/cuberite
COPY ./holoworld holoworld

EXPOSE 25565
