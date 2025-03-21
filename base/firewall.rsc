/ip firewall address-list
add address=192.168.1.1 list=WHITE-LIST
/ip firewall filter
add action=jump chain=input jump-target=common
add action=accept chain=input comment="Accept NS requests but not from WAN" \
    connection-state=new dst-port=53,123 in-interface-list=!WAN protocol=udp
add action=add-src-to-address-list address-list=BLACK-LIST \
    address-list-timeout=30m chain=input comment=\
    "Brute force detection on input" connection-state=new dst-port=8291,3022 \
    log=yes log-prefix="BRUTE FORCE ON INPUT" protocol=tcp src-address-list=\
    stage_3
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
add action=accept chain=input comment="CAPSMANAGER Discovery" \
    in-interface-list=!WAN protocol=udp src-port=5246,5247
add action=accept chain=input comment="CAPSMANAGER Discovery" dst-port=\
    5246,5247 in-interface-list=!WAN protocol=udp
add action=drop disabled=yes chain=input in-interface-list=!LAN
add action=jump chain=output jump-target=common
add action=drop chain=forward comment="Drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
add action=jump chain=forward jump-target=common
add action=accept chain=common comment=\
    "accept related, established or untracked connections" connection-state=\
    established,related,untracked
add action=drop chain=common comment="drop blacklisted" connection-state="" \
    src-address-list=BLACK-LIST
add action=accept chain=common comment="accept ipsec esp protocol" \
    connection-state="" protocol=ipsec-esp
add action=accept chain=common comment="accept ipsec udp and l2tp" \
    connection-state=new dst-port=500,1701,4500 protocol=udp
add action=accept chain=common comment="accept udp traceroute" dst-port=\
    33434-33523 protocol=udp
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
add action=return chain=common
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN

