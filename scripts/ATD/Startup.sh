#!/bin/bash
sudo ip netns add ATD
sudo ip link add atdspine1et1 type veth peer name atdspine2et1
sudo ip link add atdspine1et2 type veth peer name atdleaf1et2
sudo ip link add atdspine1et3 type veth peer name atdleaf2et2
sudo ip link add atdspine1et4 type veth peer name atdleaf3et2
sudo ip link add atdspine1et5 type veth peer name atdleaf4et2
sudo ip link add atdspine1et6 type veth peer name atdspine2et6
sudo ip link add atdspine2et2 type veth peer name atdleaf1et3
sudo ip link add atdspine2et3 type veth peer name atdleaf2et3
sudo ip link add atdspine2et4 type veth peer name atdleaf3et3
sudo ip link add atdspine2et5 type veth peer name atdleaf4et3
sudo ip link add atdleaf1et1 type veth peer name atdleaf2et1
sudo ip link add atdleaf1et4 type veth peer name atdhost1et1
sudo ip link add atdleaf1et5 type veth peer name atdhost1et3
sudo ip link add atdleaf1et6 type veth peer name atdleaf2et6
sudo ip link add atdleaf2et4 type veth peer name atdhost1et2
sudo ip link add atdleaf2et5 type veth peer name atdhost1et4
sudo ip link add atdleaf3et1 type veth peer name atdleaf4et1
sudo ip link add atdleaf3et4 type veth peer name atdhost2et1
sudo ip link add atdleaf3et5 type veth peer name atdhost2et3
sudo ip link add atdleaf3et6 type veth peer name atdleaf4et6
sudo ip link add atdleaf4et4 type veth peer name atdhost2et2
sudo ip link add atdleaf4et5 type veth peer name atdhost2et4
docker start atdspine1-net
docker stop atdspine1
docker rm atdspine1
atdspine1pid=$(docker inspect --format '{{.State.Pid}}' atdspine1-net)
sudo ln -sf /proc/${atdspine1pid}/ns/net /var/run/netns/atdspine1
sudo ip link set atdspine1et1 netns atdspine1 name et1 up
sudo ip link set atdspine1et2 netns atdspine1 name et2 up
sudo ip link set atdspine1et3 netns atdspine1 name et3 up
sudo ip link set atdspine1et4 netns atdspine1 name et4 up
sudo ip link set atdspine1et5 netns atdspine1 name et5 up
sudo ip link set atdspine1et6 netns atdspine1 name et6 up
sleep 1
docker run -d --name=atdspine1 --log-opt max-size=1m --net=container:atdspine1-net --privileged -v /workspaces/rLab-eos/configs/ATD/spine1:/mnt/flash:Z -e INTFTYPE=et -e MGMT_INTF=eth0 -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.25.0F /sbin/init systemd.setenv=INTFTYPE=et systemd.setenv=MGMT_INTF=eth0 systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
docker start atdspine2-net
docker stop atdspine2
docker rm atdspine2
atdspine2pid=$(docker inspect --format '{{.State.Pid}}' atdspine2-net)
sudo ln -sf /proc/${atdspine2pid}/ns/net /var/run/netns/atdspine2
sudo ip link set atdspine2et1 netns atdspine2 name et1 up
sudo ip link set atdspine2et2 netns atdspine2 name et2 up
sudo ip link set atdspine2et3 netns atdspine2 name et3 up
sudo ip link set atdspine2et4 netns atdspine2 name et4 up
sudo ip link set atdspine2et5 netns atdspine2 name et5 up
sudo ip link set atdspine2et6 netns atdspine2 name et6 up
sleep 1
docker run -d --name=atdspine2 --log-opt max-size=1m --net=container:atdspine2-net --privileged -v /workspaces/rLab-eos/configs/ATD/spine2:/mnt/flash:Z -e INTFTYPE=et -e MGMT_INTF=eth0 -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.25.0F /sbin/init systemd.setenv=INTFTYPE=et systemd.setenv=MGMT_INTF=eth0 systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
docker start atdleaf1-net
docker stop atdleaf1
docker rm atdleaf1
atdleaf1pid=$(docker inspect --format '{{.State.Pid}}' atdleaf1-net)
sudo ln -sf /proc/${atdleaf1pid}/ns/net /var/run/netns/atdleaf1
sudo ip link set atdleaf1et1 netns atdleaf1 name et1 up
sudo ip link set atdleaf1et2 netns atdleaf1 name et2 up
sudo ip link set atdleaf1et3 netns atdleaf1 name et3 up
sudo ip link set atdleaf1et4 netns atdleaf1 name et4 up
sudo ip link set atdleaf1et5 netns atdleaf1 name et5 up
sudo ip link set atdleaf1et6 netns atdleaf1 name et6 up
sleep 1
docker run -d --name=atdleaf1 --log-opt max-size=1m --net=container:atdleaf1-net --privileged -v /workspaces/rLab-eos/configs/ATD/leaf1:/mnt/flash:Z -e INTFTYPE=et -e MGMT_INTF=eth0 -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.25.0F /sbin/init systemd.setenv=INTFTYPE=et systemd.setenv=MGMT_INTF=eth0 systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
docker start atdleaf2-net
docker stop atdleaf2
docker rm atdleaf2
atdleaf2pid=$(docker inspect --format '{{.State.Pid}}' atdleaf2-net)
sudo ln -sf /proc/${atdleaf2pid}/ns/net /var/run/netns/atdleaf2
sudo ip link set atdleaf2et1 netns atdleaf2 name et1 up
sudo ip link set atdleaf2et2 netns atdleaf2 name et2 up
sudo ip link set atdleaf2et3 netns atdleaf2 name et3 up
sudo ip link set atdleaf2et4 netns atdleaf2 name et4 up
sudo ip link set atdleaf2et5 netns atdleaf2 name et5 up
sudo ip link set atdleaf2et6 netns atdleaf2 name et6 up
sleep 1
docker run -d --name=atdleaf2 --log-opt max-size=1m --net=container:atdleaf2-net --privileged -v /workspaces/rLab-eos/configs/ATD/leaf2:/mnt/flash:Z -e INTFTYPE=et -e MGMT_INTF=eth0 -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.25.0F /sbin/init systemd.setenv=INTFTYPE=et systemd.setenv=MGMT_INTF=eth0 systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
docker start atdleaf3-net
docker stop atdleaf3
docker rm atdleaf3
atdleaf3pid=$(docker inspect --format '{{.State.Pid}}' atdleaf3-net)
sudo ln -sf /proc/${atdleaf3pid}/ns/net /var/run/netns/atdleaf3
sudo ip link set atdleaf3et1 netns atdleaf3 name et1 up
sudo ip link set atdleaf3et2 netns atdleaf3 name et2 up
sudo ip link set atdleaf3et3 netns atdleaf3 name et3 up
sudo ip link set atdleaf3et4 netns atdleaf3 name et4 up
sudo ip link set atdleaf3et5 netns atdleaf3 name et5 up
sudo ip link set atdleaf3et6 netns atdleaf3 name et6 up
sleep 1
docker run -d --name=atdleaf3 --log-opt max-size=1m --net=container:atdleaf3-net --privileged -v /workspaces/rLab-eos/configs/ATD/leaf3:/mnt/flash:Z -e INTFTYPE=et -e MGMT_INTF=eth0 -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.25.0F /sbin/init systemd.setenv=INTFTYPE=et systemd.setenv=MGMT_INTF=eth0 systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
docker start atdleaf4-net
docker stop atdleaf4
docker rm atdleaf4
atdleaf4pid=$(docker inspect --format '{{.State.Pid}}' atdleaf4-net)
sudo ln -sf /proc/${atdleaf4pid}/ns/net /var/run/netns/atdleaf4
sudo ip link set atdleaf4et1 netns atdleaf4 name et1 up
sudo ip link set atdleaf4et2 netns atdleaf4 name et2 up
sudo ip link set atdleaf4et3 netns atdleaf4 name et3 up
sudo ip link set atdleaf4et4 netns atdleaf4 name et4 up
sudo ip link set atdleaf4et5 netns atdleaf4 name et5 up
sudo ip link set atdleaf4et6 netns atdleaf4 name et6 up
sleep 1
docker run -d --name=atdleaf4 --log-opt max-size=1m --net=container:atdleaf4-net --privileged -v /workspaces/rLab-eos/configs/ATD/leaf4:/mnt/flash:Z -e INTFTYPE=et -e MGMT_INTF=eth0 -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.25.0F /sbin/init systemd.setenv=INTFTYPE=et systemd.setenv=MGMT_INTF=eth0 systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
docker start atdhost1-net
docker stop atdhost1
docker rm atdhost1
atdhost1pid=$(docker inspect --format '{{.State.Pid}}' atdhost1-net)
sudo ln -sf /proc/${atdhost1pid}/ns/net /var/run/netns/atdhost1
sudo ip link set atdhost1et1 netns atdhost1 name et1 up
sudo ip link set atdhost1et2 netns atdhost1 name et2 up
sudo ip link set atdhost1et3 netns atdhost1 name et3 up
sudo ip link set atdhost1et4 netns atdhost1 name et4 up
sleep 1
docker run -d --name=atdhost1 --log-opt max-size=1m --net=container:atdhost1-net --privileged -v /workspaces/rLab-eos/configs/ATD/host1:/mnt/flash:Z -e INTFTYPE=et -e MGMT_INTF=eth0 -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.25.0F /sbin/init systemd.setenv=INTFTYPE=et systemd.setenv=MGMT_INTF=eth0 systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
docker start atdhost2-net
docker stop atdhost2
docker rm atdhost2
atdhost2pid=$(docker inspect --format '{{.State.Pid}}' atdhost2-net)
sudo ln -sf /proc/${atdhost2pid}/ns/net /var/run/netns/atdhost2
sudo ip link set atdhost2et1 netns atdhost2 name et1 up
sudo ip link set atdhost2et2 netns atdhost2 name et2 up
sudo ip link set atdhost2et3 netns atdhost2 name et3 up
sudo ip link set atdhost2et4 netns atdhost2 name et4 up
sleep 1
docker run -d --name=atdhost2 --log-opt max-size=1m --net=container:atdhost2-net --privileged -v /workspaces/rLab-eos/configs/ATD/host2:/mnt/flash:Z -e INTFTYPE=et -e MGMT_INTF=eth0 -e ETBA=1 -e SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 -e CEOS=1 -e EOS_PLATFORM=ceoslab -e container=docker -i -t ceosimage:4.25.0F /sbin/init systemd.setenv=INTFTYPE=et systemd.setenv=MGMT_INTF=eth0 systemd.setenv=ETBA=1 systemd.setenv=SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 systemd.setenv=CEOS=1 systemd.setenv=EOS_PLATFORM=ceoslab systemd.setenv=container=docker
