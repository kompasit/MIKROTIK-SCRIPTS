:log info message="Startup started";

:global WIFACE ("ether1", "ether2");
:global WIP ( "0.0.0.0","0.0.0.0");
:global WNET ("0.0.0.0","0.0.0.0");
:global WGW ("0.0.0.0","0.0.0.0");
:global WDIST (11,21);
:global WPING 8.8.8.8;

:global WDISTBEST 123456789;
:global WSTATE ("KO","OK");
:global TTEXT;
:global MYHOST [/system identity get name];

:local IP;
:local NET;

:foreach  iface in $WIFACE do={/ip/route/remove [find comment=($iface."-MWAN")]};
:foreach  iface in $WIFACE do={/routing/rule/remove [find comment=($iface."-MWAN")]};

/routing/rule/remove [find comment="STARTUP script"];

:foreach ipa in [/ip address find] do={
    :if (![/ip address get $ipa dynamic]) do={
        :set IP [/ip/address/get $ipa address];
        :set NET [/ip/address/get $ipa network];
        :set NET ($NET.[:pick $IP [:find $IP "/"] 100]);
        /routing/rule/add dst-address=$NET action=lookup table=main comment="STARTUP script";
    }
}

# Static rules.
# /routing rule add src-address=192.168.7.2 table=ISP2 comment="STARTUP script";

:do {} while ([ping count=2 $WPING] < 2);
:set TTEXT "System started";
/system/script/run TALERT;

:log info message="Startup ended";