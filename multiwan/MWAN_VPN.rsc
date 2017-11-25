:global WDISTBEST
:local DIST; 
:set DIST [/ip route get [find active dst-address=0.0.0.0/0 !routing-mark] distance]; 

if ($DIST!=$WDISTBEST) do={
   foreach i in [/interface find type=ovpn-out !disabled] do={
      /interface disable [find .id=$i]; 
      /interface enable [find .id=$i];
   }
}

set WDISTBEST $DIST;