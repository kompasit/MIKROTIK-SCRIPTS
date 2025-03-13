###################################
# MultiWAN for Mikrotik Router OS 7
# v. 1.0.0  11.01.2024
# (c) Oleg "Compass" Shulga
###################################

:global MWAN true;

:global WIFACE;
:global WIP;
:global WNET;
:global WGW;
:global WSTATE;
:global WDIST;
:global WDISTBEST;
:global WPING;
:global TTEXT;
:global TTEXT;

:local DIST; 
:local IP;
:local GW;
:local NET;
:local IFTYPE;
:local IFNAME;

:local scriptName "MWAN_7";

:if ( [:len [/system script job find where script="STARTUP"]] > 1) do= { :error "STARTUP script running" };
:if ( [:len [/system script job find where script=$scriptName]] > 1) do= { :error "Only single instance of MWAN can run" };

:for i from=0 to=([:len $WIFACE]-1) do={
    # Check that interface runnings
    :if (![/interface get [find name=($WIFACE->$i)] running]) do={ 
        :if (($WSTATE->$i)="OK") do={
            /ip/route/remove [find distance=($WDIST->$i)];
            :set ($WSTATE->$i) "KO";
            :set TTEXT (($WIFACE->$i)." physically down");
            :log info $TTEXT;
            /system/script/run TALERT;
        }                 
    } else={ 
        # Check that iface exist and has one IP address
        :if ([:len [/ip address find interface=($WIFACE->$i)]] = 1) do={
            :set IP [/ip address get [find interface=($WIFACE->$i)]  address];
            :set NET  [/ip address get  [find interface=($WIFACE->$i)] network];
            :set NET ($NET.[:pick $IP [:find $IP "/"] 100]);
            :set IP [:pick $IP 0 [:find $IP "/"]];
            :set ($WNET->$i)  $NET;

            :set IFTYPE [/interface get [find name=($WIFACE->$i)] type];
            :if ($IFTYPE="ether" or $IFTYPE="wlan" or $IFTYPE="vlan" or $IFTYPE="lte") do={
                :if ([/ip address get [find interface=($WIFACE->$i)] dynamic]) do={ 
                    :set $GW [/ip dhcp-client get [find interface=($WIFACE->$i)] gateway];
                } else={:set $GW ($WGW->$i);} 
            }   
            :if ($IFTYPE="ppp-out" or $IFTYPE="pptp-out" or $IFTYPE="pppoe-out") do={ 
                :set $GW [/ip address get [find interface=($WIFACE->$i)] network];
            }
            # Check that ip address or GW has changed
            :if ((($WIP->$i) != $IP) || (($WGW->$i) != $GW)) do={ 
                :if ([/ip address get [find interface=($WIFACE->$i)] dynamic]) do={
                    :log info ("New IP/GW: $IP / $GW on ".($WIFACE->$i));
                    :set ($WIP->$i) $IP; 
                    :set ($WGW->$i) $GW; 

                    /ip route remove [find comment=(($WIFACE->$i)."-MWAN")];
                    /ip route add gateway=($WGW->$i) routing-table=("ISP".($i+1)) comment=(($WIFACE->$i)."-MWAN");

                    /routing/rule/remove [find comment=(($WIFACE->$i)."-MWAN")];
                    /routing/rule/add dst-address=($WNET->$i) action=lookup table=main comment=(($WIFACE->$i)."-MWAN");
                    /routing/rule/add src-address=($WIP->$i) action=lookup table=("ISP".($i+1)) comment=(($WIFACE->$i)."-MWAN");
                }
            # IP/GW Changed
            }
            # Check that interface is down
            :local p 0; {:do {:set p ($p + 1)} while (($p < 5) && ([/ping $WPING src-address=($WIP->$i) interval=3 count=1]=0))};
            :if (($p=5) && (($WSTATE->$i)="OK")) do={
                /ip route remove [find distance=($WDIST->$i)];
                :set ($WSTATE->$i) "KO";
                :set TTEXT (($WIFACE->$i)." DOWN");
                :log info $TTEXT;
                /system script run TALERT;
            }
            # Check that interface is up
            :local p 0; {:do {:set p ($p + 1)} while (($p < 5) && ([/ping $WPING src-address=($WIP->$i) interval=3 count=1]=1))};
            :if (($p=5) && (($WSTATE->$i)="KO")) do={
                /ip route add gateway=($WGW->$i) distance=($WDIST->$i) comment=(($WIFACE->$i)."-MWAN");
                :set ($WSTATE->$i) "OK";
                :set TTEXT (($WIFACE->$i)." UP");
                :log info $TTEXT;
                /system script run TALERT;
            }
        # iface exist and has one IP address
        }
    # iface running
    }
}


# Some reactions on change gateway (ovpn only now)
:set DIST [/ip route get [find active dst-address=0.0.0.0/0 routing-table=main] distance]; 

if ($DIST!=$WDISTBEST) do={
   foreach i in [/interface find type=ovpn-out !disabled] do={
      /interface disable [find .id=$i]; 
      /interface enable [find .id=$i];
   }
  :set GW [/ip route get [find active dst-address=0.0.0.0/0 routing-table=main] immediate-gw];
  :set TTEXT "GW is $GW";
  /system script run TALERT;
}
 
set WDISTBEST $DIST;

:set MWAN false;
