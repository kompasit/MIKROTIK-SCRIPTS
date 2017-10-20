# oct/20/2017 16:39: 6 by RouterOS 6.40.4
# software id = 0SFK-JZ0T
#
#Flags: I - invalid 
# 0   name="STARTUP" owner="admin" policy=read,write,policy,test 
#     last-started=oct/20/2017 16:36:05 run-count=13 
#     source=
       :global WDISTBEST 123456789;
       :global WDIST (11,21);
       :global WGW ("0.0.0.0","0.0.0.0.");
       :global WIFACE ("ether1", "ether2");
       :global WIP ( "0.0.0.0","0.0.0.0");
       :global WNET ("0.0.0.0","0.0.0.0");
       :global WSTATE ("KO","KO");
       
       :global WPING "8.8.8.8";
       
       
       :global TTEXT;
       :global MYHOST [/system identity get name];
       
       
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
                /ip route rule add dst-address=$NET table=main comment="STARTUP script";
           }
       }
       
       # Static rules 
       # /ip route rule add src-address=77.88.216.42 table=ISP1 comment="STARTUP script";
       
       :set TTEXT "System started";
       /system script run TALERT;
