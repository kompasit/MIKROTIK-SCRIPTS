# 2   name="MWAN-VPN" owner="admin" policy=read,write,policy,test 
#     last-started=oct/20/2017 16:38:46 run-count=1416 source=
       :global WDISTBEST
       :local DIST; 
       :set DIST [/ip route get [find active dst-address=0.0.0.0/0 !routing-mark] distance]; 
       
       if ($DIST!=$WDISTBEST) do={
          foreach i in [/interface find type=ovpn-out] do={
             /interface disable [find .id=$i]; 
             /interface enable [find .id=$i];
          }
       }
       
       set WDISTBEST $DIST;
