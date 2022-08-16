
to solve for `Network plugin returns error: No CNI configuration file in /etc/cni/net.d/. Has your network provider started`
was missing the `containernetworking-plugins` package.

```
$ journalctl -u crio -f
Aug 16 15:39:39 fedora crio[4694]: time="2022-08-16 15:39:39.346871048+02:00" level=info msg="RDT not available in the host system"
Aug 16 15:39:39 fedora crio[4694]: time="2022-08-16 15:39:39.353249424+02:00" level=warning msg="Error validating CNI config file /etc/cni/net.d/10-flannel.conflist: [failed to find plugin \"portmap\" in path [/opt/cni/bin /usr/libexec/cni]]"
Aug 16 15:39:39 fedora crio[4694]: time="2022-08-16 15:39:39.353752830+02:00" level=warning msg="Error validating CNI config file /etc/cni/net.d/100-crio-bridge.conf: [failed to find plugin \"bridge\" in path [/opt/cni/bin /usr/libexec/cni]]"
Aug 16 15:39:39 fedora crio[4694]: time="2022-08-16 15:39:39.353984663+02:00" level=warning msg="Error validating CNI config file /etc/cni/net.d/200-loopback.conf: [failed to find plugin \"loopback\" in path [/opt/cni/bin /usr/libexec/cni]]"
Aug 16 15:39:39 fedora crio[4694]: time="2022-08-16 15:39:39.354117274+02:00" level=error msg="Error loading CNI config file /etc/cni/net.d/99-dummy.conf: error parsing configuration: unexpected end of JSON input"
Aug 16 15:39:39 fedora crio[4694]: time="2022-08-16 15:39:39.354156496+02:00" level=info msg="Updated default CNI network name to "
Aug 16 15:39:39 fedora crio[4694]: time="2022-08-16 15:39:39.516989815+02:00" level=info msg="Serving metrics on :9537 via HTTP"
Aug 16 15:39:39 fedora systemd[1]: Started crio.service - Container Runtime Interface for OCI (CRI-O).
Aug 16 15:39:48 fedora crio[4694]: time="2022-08-16 15:39:48.761282549+02:00" level=info msg="Checking image status: k8s.gcr.io/pause:3.4.1" id=65a97997-1843-479a-8e80-5fe147773fd3 name=/runtime.v1alpha2.ImageService/ImageStatus
Aug 16 15:39:48 fedora crio[4694]: time="2022-08-16 15:39:48.763018323+02:00" level=info msg="Image k8s.gcr.io/pause:3.4.1 not found" id=65a97997-1843-479a-8e80-5fe147773fd3 name=/runtime.v1alpha2.ImageService/ImageStatus
^C
$ sudo dnf install containernetworking-plugins
Last metadata expiration check: 0:34:19 ago on Tue 16 Aug 2022 15:09:34 CEST.
Dependencies resolved.
==============================================================================================================================================================================
 Package                                                Architecture                       Version                                   Repository                          Size
==============================================================================================================================================================================
Installing:
 containernetworking-plugins                            aarch64                            1.1.1-8.fc37                              rawhide                            7.4 M

Transaction Summary
==============================================================================================================================================================================
Install  1 Package

Total download size: 7.4 M
Installed size: 51 M
Is this ok [y/N]: 
```