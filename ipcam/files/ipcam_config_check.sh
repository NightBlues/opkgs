#!/bin/sh

echo "Staring IPCAM check..."

. /lib/functions.sh


case "$(board_name)" in
    bananapi,bpi-r2|\
        bananapi,bpi-r64)
        case $(fw_printenv bootconf) in
            *config-mt7622-bananapi-bpi-r64-sata)
                echo "fw_setenv: already bootconf=config-mt7622-bananapi-bpi-r64-sata";;
            *)
                echo "[C] fw_setenv: setting bootconf=config-mt7622-bananapi-bpi-r64-sata"
                fw_setenv bootconf config-mt7622-bananapi-bpi-r64-sata
                ;;
        esac
        ;;
esac

# version=$(uci get ipcam.ipcam.version 2>/dev/null || echo 0)
# [ -e /etc/config/ipcam ] && exit 0

case $(uci get fstab.storage 2>/dev/null||echo "") in
	mount) echo "fstab: storage config exist";;
	*)
        echo "[C] fstab: add storage config"
		uci -qm import fstab <<EOF
config mount 'storage'
	option target '/storage'
#	option uuid '9a96685a-13b0-4e65-838e-c7f689ed45ec'
	option device 'IPCAM_STORAGE_DEVICE'
	option enabled '1'
EOF
		;;
esac

case $(uci get network.wg0 2>/dev/null || echo "") in
	interface) echo "network: wg0 config exist";;
	*)
        echo "[C] network: creating wg0 config"
		uci -qm import network <<EOF
config interface 'wg0'
	option proto 'wireguard'
	option private_key 'IPCAM_WG_PRIV_KEY'
	list addresses 'IPCAM_WG_IP'
	option mtu '1380'

config wireguard_wg0 'wgclient'
	option public_key 'IPCAM_WG_SRV_PUB_KEY'
	option endpoint_host 'IPCAM_WG_SRV_PUB_HOST'
	option endpoint_port 'IPCAM_WG_SRV_PUB_PORT'
	option persistent_keepalive '15'
	option route_allowed_ips '1'
	list allowed_ips 'IPCAM_WG_PREFIX'
#	list allowed_ips '192.168.2.0/24' # other ipcam "edges"
EOF
		;;
esac

# hope @zone[0] is lan
uci rename firewall.@zone[0]=$(uci get firewall.@zone[0].name)
uci rename firewall.@zone[1]=$(uci get firewall.@zone[1].name)
case "$(uci get firewall.lan.network)" in
	*wg0*) echo "firewall: wg0 already in lan";;
	*)
        echo "[C] firewall: adding wg0 to lan"
		uci add_list firewall.lan.network="wg0";
		uci commit firewall
    ;;
esac

case $(uci get network.lan.ipaddr 2>/dev/null || echo "") in
    IPCAM_WG_LAN_IPADDR) echo "network: lan.ipaddr is correct";;
    *)
        echo "[C] network: setting lan.ipaddr"
        uci set network.lan.ipaddr='IPCAM_WG_LAN_IPADDR'
        uci commit network
        ;;
esac

case $(uci get dhcp.@host[0].name 2>/dev/null || echo "") in
	cam1) echo "dhcp: cam1 already added";;
	*)
        echo "[C] dhcp: adding cam1"
        uci -qm import dhcp <<EOF
config host 'cam1'
        option 'name' 'cam1'
        option 'ip'   'IPCAM_CAM1_IP'
        option 'mac'  'IPCAM_CAM1_MAC_ADDR'
EOF
		;;
esac

echo <EOF >> /etc/crontabs/root
50 8 * * * sh -c 'storageclean.sh'
55 8 * * * sh -c 'send_notify_text.sh "$(stats.sh)"'
57 8 * * * sh -c 'cd /storage/camera-all; send_notify_video.sh $(ls -rt | tail -2 | head -1)'
10 20 * * * sh -c 'send_notify_text.sh "$(stats.sh)"'
0 8 * * * /etc/init.d/motion-detect start
0 17 * * * /etc/init.d/motion-detect stop
0 18 * * * /etc/init.d/motion-detect stop
0 19 * * * /etc/init.d/motion-detect stop
0 20 * * * /etc/init.d/motion-detect stop
0 21 * * * /etc/init.d/motion-detect stop
0 22 * * * /etc/init.d/motion-detect stop
0 23 * * * /etc/init.d/motion-detect stop
0 0 * * * /etc/init.d/motion-detect stop
0 1 * * * /etc/init.d/motion-detect stop
0 2 * * * /etc/init.d/motion-detect stop
0 3 * * * /etc/init.d/motion-detect stop
0 4 * * * /etc/init.d/motion-detect stop
0 5 * * * /etc/init.d/motion-detect stop
0 6 * * * /etc/init.d/motion-detect stop
0 7 * * * reboot

EOF
