/caps-man channel
add band=2ghz-g/n  frequency=2462 name=channel2 tx-power=20
add band=5ghz-n/ac frequency=5765 name=channel5 tx-power=20

/caps-man datapath
add bridge=bridge1 client-to-client-forwarding=yes name=datapath_work
add bridge=bridge2 client-to-client-forwarding=no  name=datapath_guest

/caps-man security
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm name=security_work passphrase=very-secret-work-password
add authentication-types=wpa2-psk encryption=aes-ccm group-encryption=aes-ccm name=security_guest passphrase=secret-guest-password

/caps-man configuration
add channel=channel2 datapath=datapath_work mode=ap name=cfg2w rx-chains=0,1,2 security=security_work ssid=WORK tx-chains=0,1,2
add channel=channel5 datapath=datapath_work mode=ap name=cfg5w rx-chains=0,1,2 security=security_work ssid=WORK5 tx-chains=0,1,2
add channel=channel2 datapath=datapath_guest mode=ap name=cfg2g rx-chains=0,1,2 security=security_guest ssid=GUESTS tx-chains=0,1,2
add channel=channel5 datapath=datapath_guest mode=ap name=cfg5g rx-chains=0,1,2 security=security_guest ssid=GUESTS5 tx-chains=0,1,2

/caps-man manager
set enabled=yes

/caps-man provisioning
add action=create-dynamic-enabled hw-supported-modes=gn master-configuration=cfg2w slave-configurations=cfg2g
add action=create-dynamic-enabled hw-supported-modes=an master-configuration=cfg5w slave-configurations=cfg5g