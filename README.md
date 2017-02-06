Holocraft-server
===================

Overview

## Description

Holocraft is developing to connect the virtual world of Minecraft and the real world. In order to connect the virtual space and the real world, Hololens is necessary.


## How to run Holocraft

1. **Install Minecraft: [minecraft.net](https://minecraft.net)**

    The Minecraft client hasn't been modified, just get the official release.

2. **Pull or build Holocraft image:** (an offical image will be available soon)

    ```
    docker pull 135yshr/holocraft
    ```
    or

    ```
    git clone https://github.com/135yshr/Holocraft-server.git
    docker build -t 135yshr/holocraft holocraft
    ```

3. **Run Holocraft container:**

    ```
    docker run -t -i -d -p 25565:25565 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name holocraft \
    135yshr/holocraft
    ```

    Mounting `/var/run/docker.sock` inside the container is necessary to send requests to the Docker remote API.

    The default port for a Minecraft server is *25565*, if you prefer a different one: `-p <port>:25565`

4. **Open Minecraft > Multiplayer > Add Server**

    The server address is the IP of Docker host. No need to specify a port if you used the default one.

    If you're using [Holocraft Machine](https://docs.docker.com/machine/install-machine/): `docker-machine ip <machine_name>`

5. **Join Server!**

    You should see at least one container in your world, which is the one hosting your Holocraft server.

    You can start, stop and remove containers interacting with levers and buttons. Some Docker commands are also supported directly via Minecraft's chat window, which is displayed by pressing the `T` key (default) or `/` key.

## Contribution

## Licence

Based on the [Dockercraft](https://github.com/docker/dockercraft) has created a Slackraft.

[MIT](https://135yshr.mit-license.org)

## Author

[135yshr](https://github.com/135yshr)
