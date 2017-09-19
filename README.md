# Simple setup to connect to VPN through an ssh proxy server

The scenario is this:
* Network issues on the intranet/LAN whatever leads to no access
  to global internet and no DNS lookups.
* However, you have ssh access to a machine that
  has network access.

This script helps you to set up VPN access to the internet through the ssh server
you have access to.


## Prerequesites

* OpenVPN
* Virtualenvwrapper


## Setup ssh config

In ~/.ssh/config you need an entry to the ssh server:

```
Host ssh_server
	Hostname  <hostname or IP>
	Port	  22
	User 	  bro
	IdentityFile  </path/to/idenfity/file>

```

If the ssh server is not directly accessible, add a proxy server to the config:

```
Host ssh_server
	Hostname  <hostname or IP>
	Port	  22
	User 	  <username>
	ProxyCommand  ssh -W %h:%p ssh_proxy_server
	IdentityFile  </path/to/idenfity/file>

Host ssh_proxy_server
	Hostname  <hostname or IP>
	Port	  22
	User 	  <username>
	IdentityFile  </path/to/idenfity/file>
```

## Options

Edit conf.env and set the variables:

```
SSH_SERVER=<name of ssh server to route traffic through>
OPENPVN_CONFIG=/path/to/openvpn/config/client.conf
OPENPVN_ROUTE=--route <ip-of-ssh-server> <netmask> <gateway>
```

The route option is needed to add the correct route in the routing table for
the traffic going through the ssh tunnel.

ip-of-ssh-server: The IP of the ssh server used for the ssh tunnel. If an ssh proxy is needed to access the
                  ssh server, use the ssh proxy server's IP.
netmask: E.g. 255.255.255.255
gateway: IP of the physical interface that must be used to access the ssh server.
