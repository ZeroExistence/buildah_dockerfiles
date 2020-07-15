# alpine-syncthing_relay

Custom alpine image in deploying syncthing relay node. If you want to contribute some bandwidth with the Syncthing project, this would be greatly appreciated.

This container is used to relay communications between two Syncthing peers that can't have a direct connection with each other.

## How to use

1. Copy the alpine-syncthing_relay.Dockerfile. Customize it as you see fit.
2. Build it by running this command.
```bash
buildah bud -f alpine-syncthing_relay.Dockerfile -t alpine-syncthing_relay .
```
3. Create named volume for this container. This is just to save private keys of your relay, but it's not really important though.
```bash
podman volume create alpine-syncthing_relay
```
4. Run the container. Don't adjust the ports, since those are the default ports used by Syncthing relay.
```bash
podman run --rm -a stdout -a stderr --name alpine-syncthing_relay -v alpine-syncthing_relay:/data -p 22067:22067 -p 22070:22070 alpine-syncthing_relay:latest
```
5. You can verify if your relay has joined the public relay lists by having this log on your log output.
```
pool.go:54: Joined https://relays.syncthing.net/endpoint rejoining in 48m0s
```
6. Once you verify is everything is working, run your container as a system service. This is to manage the container using systemd. One benefits of running it as a service is it's auto restart function. Make a file in /etc/systemd/system/ folder, and paste this configuration.
```
  [Unit]
  Description=alpine-syncthing_relay service

  [Service]
  Restart=always
  RestartSec=15s
  ExecStart=/usr/bin/podman run --rm -a stdout -a stderr --name alpine-syncthing_relay -v alpine-syncthing_relay:/data -p 22067:22067 -p 22070:22070 alpine-syncthing_relay:latest

  ExecStop=-/usr/bin/podman stop -t 15 "alpine-syncthing_relay"

  [Install]
  WantedBy=local.target
```

## Guide and Documentations
For complete details in setting up Syncthing relays, just visit the [Syncthing Relay Server guide](https://docs.syncthing.net/users/strelaysrv.html#strelaysrv), or just message me on my discord, ZeroExistence#8691.


## Contribution
I got the Dockerfile from [Kyle Manna's docker-syncthing-relay repository](https://github.com/kylemanna/docker-syncthing-relay).
