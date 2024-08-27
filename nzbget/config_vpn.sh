# !/bin/bash
nordvpn login token e9f2abe17242c0abd2f76779ff48acb9c35fa2d726b3099eb85f6f1350ad85f9
nordvpn connect
nordvpn whitelist add subnet 10.56.57.0/28
nordvpn whitelist add subnet 10.0.2.15/28 # Virtual box network

# meshnet
nordvpn set meshnet on

