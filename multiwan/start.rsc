##################################
# MultiWAN for Mikrotik Router OS
# v. 0.2.2  19.02.2017
# (c) Oleg "Kompas" Shulga
##################################
#
# Startup script example for multiwan
#



:global MWAN false;
:global WSTART false;
:global WDISTBEST 65534;
:global WDIST (11,21);
:global WGW ("0.0.0.0", "212.1.115.141");
:global WIFACE ("pppoe-DG", "WAN2");
:global WIP ("0.0.0.0", "212.1.115.142");
:global WNET ("0.0.0.0", "212.1.115.140/30");
:global WSTATE ("KO","KO");
:global WPING (true,true);



:local IP;
:local NET;


:delay 15;

:foreach  iface in $WIFACE do={/ip route remove [find comment=($iface."-MWAN")]};
/ip route rule remove [/ip route rule find];

:foreach ipa in [/ip address find] do={
    :if (![/ip address get $ipa dynamic]) do={
         :set IP [/ip address get $ipa address];
         :set NET [/ip address get $ipa network];
         :set NET ($NET.[:pick $IP [:find $IP "/"] 100]);
         /ip route rule add dst-address=$NET table=main comment="STARTUP";
    }
}

# Static rules
/ip route rule
add src-address=212.1.115.142/32 table=ISP2;
add src-address=217.112.209.56/29 table=ISP1;
add src-address=212.1.113.120/29 table=ISP2;

global WSTART true;