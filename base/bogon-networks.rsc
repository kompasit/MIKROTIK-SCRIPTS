/ip route

add comment="BOGON: \"This\" Network" distance=254 dst-address=0.0.0.0/8 \
    type=blackhole
add comment="BOGON: Private-Use Networks" distance=254 dst-address=10.0.0.0/8 \
    type=blackhole
add comment="BOGON: Shared address Space. RFC 6598" distance=254 dst-address=\
    100.64.0.0/10 type=blackhole
add comment="BOGON: Loopback" distance=254 dst-address=127.0.0.0/8 type=\
    blackhole
add comment="BOGON: Link Local" distance=254 dst-address=169.254.0.0/16 type=\
    blackhole
add comment="BOGON: Private-Use Networks" distance=254 dst-address=\
    172.16.0.0/12 type=blackhole
add comment="BOGON: IETF Protocol Assignments" distance=254 dst-address=\
    192.0.0.0/24 type=blackhole
add comment="BOGON: TEST-NET-1" distance=254 dst-address=192.0.2.0/24 type=\
    blackhole
add comment="BOGON: 6to4 Relay Anycast" distance=254 dst-address=\
    192.88.99.0/24 type=blackhole
add comment="BOGON: Private-Use Networks" distance=254 dst-address=\
    192.168.0.0/16 type=blackhole
add comment="BOGON: Network Interconnect Device Benchmark Testing" distance=\
    254 dst-address=198.18.0.0/15 type=blackhole
add comment="BOGON: TEST-NET-2" distance=254 dst-address=198.51.100.0/24 \
    type=blackhole
add comment="BOGON: TEST-NET-3" distance=254 dst-address=203.0.113.0/24 type=\
    blackhole
add comment="BOGON: Multicast" distance=254 dst-address=224.0.0.0/4 type=\
    blackhole
add comment="BOGON: Reserved for Future Use" distance=254 dst-address=\
    240.0.0.0/4 type=blackhole
add comment="BOGON: Limited Broadcast" distance=254 dst-address=\
    255.255.255.255/32 type=blackhole
