# 1   name="MWAN" owner="admin" policy=read,write,policy,test 
#     last-started=oct/20/2017 16:38:45 run-count=1451 
#     source=
       ##################################
       # MultiWAN for Mikrotik Router OS
       # v. 0.3.1  29.07.2015
       # (c) Oleg "Kompas" Shulga
       ##################################
       
       :global MWAN true;
       
       :global WIFACE;
       :global WIP;
       :global WNET;
       :global WGW;
       :global WSTATE;
       :global WDIST;
       :global WPING;
       :global TTEXT;
       
       
       :local IP;
       :local IP0;
       :local NET;
       :local IFTYPE;
       :local IFNAME;
       
       :local scriptName "MWAN";
       :if ( [:len [/system script job find where script=$scriptName]] > 1) do= { :error "single instance" };
       
       :for i from=0 to=([:len $WIFACE]-1) do={
       
       # Check that interface runnings
           :if (![/interface get [find name=($WIFACE->$i)] running]) do={ 
               :if (($WSTATE->$i)="OK") do={
                   :log info (($WIFACE->$i)." do not running");
                   /ip route remove [find distance=($WDIST->$i)];
                   :set ($WSTATE->$i) "KO";
               }
       
       # Check that ip address on that interface exists and only one instance
           } else={ :if ([:len [/ip address find interface=($WIFACE->$i)]] = 1) do={
               :set IP [/ip address get [find interface=($WIFACE->$i)]  address];
               :set NET  [/ip address get  [find interface=($WIFACE->$i)] network];
               :set NET ($NET.[:pick $IP [:find $IP "/"] 100]);
               :set IP [:pick $IP 0 [:find $IP "/"]];
               :set ($WNET->$i)  $NET;
                  
       #:log info ("DEBUG: IP: $IP on ".($WIFACE->$i));
         
       
       # Check that ip address has changed
               :if (($WIP->$i) != $IP) do={ 
               :if ([/ip address get [find interface=($WIFACE->$i)] dynamic]) do={
                   :log info ("New IP: $IP on ".($WIFACE->$i));
                   :set ($WIP->$i) $IP; 
                   :set IFTYPE [/interface get [find name=($WIFACE->$i)] type];
                   :if ($IFTYPE="ether") do={ :set ($WGW->$i) [/ip dhcp-client get [find interface=($WIFACE->$i)] gateway];}
                   :if ($IFTYPE="wlan") do={ :set ($WGW->$i) [/ip dhcp-client get [find interface=($WIFACE->$i)] gateway];}
                   :if ($IFTYPE="lte") do={ :set ($WGW->$i) [/ip dhcp-client get [find interface=($WIFACE->$i)] gateway];}
                   :if ($IFTYPE="ppp-out") do={ :set ($WGW->$i) [/ip address get [find interface=($WIFACE->$i)] network];}
                   :if ($IFTYPE="pptp-out") do={ :set ($WGW->$i) [/ip address get [find interface=($WIFACE->$i)] network];}
                   :if ($IFTYPE="pppoe-out") do={ :set ($WGW->$i) [/ip address get [find interface=($WIFACE->$i)] network];}
       
                    /ip route remove [find comment=(($WIFACE->$i)."-MWAN")];
                    /ip route rule remove [find comment=(($WIFACE->$i)."-MWAN")];
                    /ip route add gateway=($WGW->$i) routing-mark=("ISP".($i+1)) comment=(($WIFACE->$i)."-MWAN");
                    /ip route rule add dst-address=($WNET->$i) table=main comment=(($WIFACE->$i)."-MWAN");
                    /ip route rule add src-address=($WIP->$i) table=("ISP".($i+1)) comment=(($WIFACE->$i)."-MWAN");
                }
                }
       
       # Check that interface is down
              :local p 0; {:do {:set p ($p + 1)} while (($p < 5) && ([/ping $WPING src-address=($WIP->$i) interval=3 count=1]=0))};
              :if (($p=5) && (($WSTATE->$i)="OK")) do={
                   :set IFNAME ($WIFACE->$i); 
                   :set TTEXT "$IFNAME Up";
                   :log info $TTEXT;
                   /system script run TALERT;
                   /ip route remove [find distance=($WDIST->$i)];
                   :set ($WSTATE->$i) "KO";
               }
       
       # Check that interface is up
              :local p 0; {:do {:set p ($p + 1)} while (($p < 5) && ([/ping $WPING src-address=($WIP->$i) interval=3 count=1]=1))};
              :if (($p=5) && (($WSTATE->$i)="KO")) do={
                   :set IFNAME ($WIFACE->$i); 
                   :set TTEXT "$IFNAME Up";
                   :log info $TTEXT;
                   /system script run TALERT;
                  :set ($WSTATE->$i) "OK";
                  /ip route add gateway=($WGW->$i) distance=($WDIST->$i) comment=(($WIFACE->$i)."-MWAN");
              }
           }}
       } 
       
       /system script run [find where name="MWAN-VPN"]
       
       :set MWAN false;
