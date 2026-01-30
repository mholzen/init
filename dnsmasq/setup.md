# dnsmasq setup

## On the Ubuntu server (ubuntu-1 / 192.168.50.3)

### Install dnsmasq

```
sudo apt install dnsmasq
```

### Deploy configuration

```
sudo cp dnsmasq.conf /etc/dnsmasq.d/dnsmasq.conf
sudo cp dnsmasq.hosts /etc/dnsmasq.hosts
```

Note: config files go in `/etc/dnsmasq.d/`, but the hosts file goes in `/etc/dnsmasq.hosts` — files in `dnsmasq.d/` are parsed as config, not hosts format.

### Disable systemd-resolved (conflicts with dnsmasq on port 53)

```
sudo systemctl disable --now systemd-resolved
sudo rm /etc/resolv.conf
echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf
```

### Start dnsmasq

```
sudo systemctl enable --now dnsmasq
```

### Verify

```
dig @127.0.0.1 ubuntu-1.home
dig @127.0.0.1 google.com
```

## On the Asus router

1. Open the router admin UI (typically http://192.168.50.1)
2. Go to **LAN** > **DHCP Server**
3. Set **DNS Server 1** to `192.168.50.3` (ubuntu-1)
4. Optionally set **DNS Server 2** to `1.1.1.1` as a fallback if the Ubuntu server is down
5. Apply and reboot the router

Clients will pick up the new DNS server on their next DHCP lease renewal. To force a renewal on a client, reconnect to the network or run `sudo dhclient -r && sudo dhclient` (Linux) or toggle Wi-Fi off/on.

## Adding local DNS records

Add entries to `/etc/dnsmasq.hosts` in standard hosts file format:

```
192.168.50.10  mydevice  mydevice.home
```

Then reload: `sudo systemctl restart dnsmasq`

## Adding CNAME aliases

Add to `/etc/dnsmasq.d/dnsmasq.conf`:

```
cname=alias,target.home
```

Then reload: `sudo systemctl restart dnsmasq`
