
Downloaded F37 server from: https://fedoraproject.org/wiki/Test_Results:Fedora_37_Rawhide_20220806.n.0_Server
file: https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20220806.n.0/compose/Server/aarch64/images/Fedora-Server-Rawhide-20220806.n.0.aarch64.raw.xz

Used RPi Imager
to flash it to SD Card

Booted RPi400 with the SD Card.
Followed 1st time install of Fedora 37.

Followed ~similar instruction at https://blog.while-true-do.io/fedora-raspberrypi-setup/
and https://fedoraproject.org/wiki/Architectures/ARM/Raspberry_Pi#Resizing_the_root_partition

```sh
# checked with `lsblk` for mmcblk
growpart /dev/mmcblk0 3
sudo growpart /dev/mmcblk0 3
sudo pvresize /dev/mmcblk0p3
# didn't work sudo lvextend -l +100%FREE /dev/fedora/root
# ls -l /dev/f*
sudo lvextend -l +100%FREE /dev/fedora_fedora/root
sudo xfs_growfs -d /
```

bonjour with

```sh
sudo dnf install -y nss-mdns avahi
# used `hostname` to check hostname, using `fedora` as default is fine for me.
systemctl enable --now avahi-daemon.service
```

getting started microshift with https://microshift.io/docs/getting-started/

Using microshift from github main releases/getting started ended up with problem reported as https://github.com/openshift/microshift/issues/859


Updated microshift manually from github nightly following ~similar to https://medium.com/@ben.swinney_ce/openshift-raspberry-pi-2e78f2990395#e1e1
as:
```sh
sudo bash # (do the following as root)
curl -L https://github.com/openshift/microshift/releases/download/nightly/microshift-linux-arm64 > /usr/local/bin/microshift
chmod +x /usr/local/bin/microshift
cp /usr/lib/systemd/system/microshift.service /etc/systemd/system/microshift.service
sed -i "s|/usr/bin|/usr/local/bin|" /etc/systemd/system/microshift.service
systemctl daemon-reload
exit # (exit as root)
```

refreshed kube config

```sh
sudo cat /var/lib/microshift/resources/kubeadmin/kubeconfig > ~/.kube/config
```

updated crio to 1.24
restarted a few times
from:

```sh
$ sudo crictl info
{
  "status": {
    "conditions": [
      {
        "type": "RuntimeReady",
        "status": true,
        "reason": "",
        "message": ""
      },
      {
        "type": "NetworkReady",
        "status": false,
        "reason": "NetworkPluginNotReady",
        "message": "Network plugin returns error: No CNI configuration file in /etc/cni/net.d/. Has your network provider started?"
      }
    ]
  }
}
```

now resulted into:
```sh
sudo crictl info
{
  "status": {
    "conditions": [
      {
        "type": "RuntimeReady",
        "status": true,
        "reason": "",
        "message": ""
      },
      {
        "type": "NetworkReady",
        "status": true,
        "reason": "",
        "message": ""
      }
    ]
  }
}
```

Deploy an K8s app with https://microshift.io/docs/user-documentation/networking/exposing-services/#service-of-type-nodeport

Accessing http://fedora.local:32681/ works from external computer/hosts as well.

Instead of NodePort, to use ingress route, follow: https://microshift.io/docs/user-documentation/networking/exposing-services/#example
is now available externally from: http://fedora.local:30001/
(but not http://192.168.1.66:30001/)

Subdomain .local eg (`nginx.fedora.local`) mdns did not work despite applying: https://microshift.io/docs/user-documentation/networking/mdns/#notes-for-linux
