# 2025-03-22 11:48:07 by RouterOS 7.17.2
# software id = QKYH-EY6W
#
# model = RB750Gr3
# serial number = 8AFF09F464EF
/ip firewall filter
add action=jump chain=input jump-target=common
add action=accept chain=input comment=Zanzibar connection-state=new dst-port=\
    53,161 protocol=udp src-address-list=MONITORS
add action=accept chain=input connection-state=new dst-port=53,123 \
    in-interface-list=!WAN protocol=udp
add action=accept chain=input connection-state=new dst-port=51820 protocol=\
    udp
add action=add-src-to-address-list address-list=BLACK-LIST \
    address-list-timeout=1h30m chain=input connection-state=new dst-port=\
    8291,3022 log=yes log-prefix="BRUT FORCE DETECTED " protocol=tcp \
    src-address-list=stage_3
add action=add-src-to-address-list address-list=stage_3 address-list-timeout=\
    1m chain=input connection-state=new dst-port=8291,3022 protocol=tcp \
    src-address-list=stage_2
add action=add-src-to-address-list address-list=stage_2 address-list-timeout=\
    1m chain=input connection-state=new dst-port=8291,3022 protocol=tcp \
    src-address-list=stage_1
add action=add-src-to-address-list address-list=stage_1 address-list-timeout=\
    1m chain=input connection-state=new dst-port=8291,3022 protocol=tcp \
    src-address-list=!WHITE-LIST
add action=accept chain=input connection-state=new dst-port=8291,3022 \
    protocol=tcp
# Don't forget to enable for production
add action=reject chain=input disabled=yes in-interface-list=WAN reject-with=\
    icmp-network-unreachable
add action=jump chain=output jump-target=common
add action=drop chain=forward comment="Drop all from WAN not DSTNATed" \
    connection-nat-state=!dstnat connection-state=new in-interface-list=WAN \
    ipsec-policy=in,none
add action=jump chain=forward jump-target=common
add action=accept chain=forward connection-state=new out-interface-list=WAN
add action=reject chain=forward disabled=yes reject-with=\
    icmp-admin-prohibited
add action=accept chain=common comment="Related, established" \
    connection-state=established,related
add action=reject chain=common connection-state="" reject-with=\
    icmp-host-unreachable src-address-list=BLACK-LIST
add action=accept chain=common connection-state="" dst-address-list=INTRANET \
    src-address-list=INTRANET
add action=accept chain=common comment="IPIP tunnels" connection-state="" \
    protocol=ipencap
add action=accept chain=common comment="gre tunneling proto" disabled=yes \
    protocol=gre
add action=accept chain=common connection-state="" protocol=ospf
add action=accept chain=common connection-state="" protocol=ipsec-esp
add action=accept chain=common connection-state="" protocol=ipsec-ah
add action=accept chain=common connection-state=new dst-port=500,1701,4500 \
    protocol=udp
add action=accept chain=common comment="accept icmp echo-replay" \
    icmp-options=0:0-255 protocol=icmp
add action=accept chain=common comment="accept icmp dest. unreachable" \
    icmp-options=3:0-255 protocol=icmp
add action=accept chain=common comment="accept icmp source quench" \
    icmp-options=4:0-255 protocol=icmp
add action=accept chain=common comment="accept icmp echo-request" \
    icmp-options=8:0-255 protocol=icmp
add action=accept chain=common comment="accept icmp time exceeded" \
    icmp-options=11:0-255 protocol=icmp
add action=accept chain=common comment="accept icmp parameter problem" \
    icmp-options=12:0-255 protocol=icmp
add action=accept chain=common comment="accept udp traceroute" dst-port=\
    33434-33523 protocol=udp
add action=return chain=common
