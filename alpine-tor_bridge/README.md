# alpine-tor_bridge

Custom alpine image in deploying TOR bridge.

## How to use

1. Copy the alpine-tor_bridge.Dockerfile. Customize it as you see fit.
2. Build it by running this command.
```bash
buildah bud -f alpine-tor_bridge.Dockerfile -t alpine-tor_bridge .
```
3. Create named volume for this container.
```bash
podman volume create alpine-tor_bridge
```
4. Copy the torrc.sample to the named volume on your host system. Rename it to torrc. Customized it as needed. Just don't change the value of DataDirectory to keep your TOR keys safe and persistent. Change the permission of torrc based on the user ID you set on the Dockerfile.
5. Run the container. Adjust the command if you changed the port settings on the torrc settings.
```bash
podman run --rm -a stdout -a stderr --name alpine-tor_bridge -p 8443:8443 -p 8448:8448 -v alpine-tor_bridge:/data localhost/alpine-tor_bridge:latest
```
6. Verify if your tor-bridge is reachable from the Internet. Your log file should have this notice.
```
[notice] Now checking whether ORPort [IP_ADDRESS]:8448 is reachable... (this may take up to 20 minutes -- look for log messages indicating success)
[notice] Self-testing indicates your ORPort is reachable from the outside. Excellent. Publishing server descriptor.
```
7. Once you verify is everything is working, run your container as a system service. This is to manage the container using systemd. One benefits of running it as a service is it's auto restart function. Make a file in /etc/systemd/system/ folder, and paste this configuration.
```
  [Unit]
  Description=alpine-tor_bridge service

  [Service]
  Restart=always
  RestartSec=15s
  ExecStart=/usr/bin/podman run --rm -a stdout -a stderr --name alpine-tor_bridge -p 8443:8443 -p 8448:8448 -v alpine-tor_bridge:/data localhost/alpine-tor_bridge:latest

  ExecStop=-/usr/bin/podman stop -t 60 "alpine-tor_bridge"

  [Install]
  WantedBy=local.target
```

## Guide and Documentations
For complete details in setting up TOR bridges, just visit the [TOR bridge setup guide](https://community.torproject.org/relay/setup/bridge/), or just message me on my discord, ZeroExistence#8691.
