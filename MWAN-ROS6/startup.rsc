:global WIFACE ("ether1","ether2","ether3");
:global WIP ( "0.0.0.0","0.0.0.0","0.0.0.0");
:global WNET ("0.0.0.0","0.0.0.0","0.0.0.0");
:global WGW ("0.0.0.0","0.0.0.0","0.0.0.0");
:global WDIST (11,21,31);
:global WSTATE ("KO","KO","KO");

:global WTIMEOUT (120,120,120);

:global WMINTIMEOUT 60;
:global WMAXTIMEOUT 3600;

:global WPING 8.8.8.8;

:global WDISTBEST 123456789;

:global TTEXT;
:global MYHOST [/system identity get name];

:local IP;
:local NET;

:foreach  iface in $WIFACE do={/ip route remove [find comment=($iface."-MWAN")]};
/ip route rule remove [/ip route rule find comment="STARTUP script"];

:foreach ipa in [/ip address find] do={
    :if (![/ip address get $ipa dynamic]) do={
        :set IP [/ip address get $ipa address];
        :set NET [/ip address get $ipa network];
        :set NET ($NET.[:pick $IP [:find $IP "/"] 100]);
        /ip route rule add dst-address=$NET table=main comment="STARTUP script";
    }
}

# Static rules.
# /ip route rule add src-address=192.168.7.2 table=ISP2 comment="STARTUP script";

:do {} while ([ping count=2 $WPING] < 2);
:set TTEXT "System started";
/system script run TALERT;
