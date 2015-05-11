iptable:
    #公用IP
    public:
        - 101.95.5.22/32
        - 27.115.76.0/29
        - 122.226.111.55/32
        - 223.202.34.253/32
        - 223.202.32.165/32
        - 223.202.45.25/32
        - 60.191.252.165/32
        
    #以下是各机房的外网和内网IP.
    jinhua:
        wlan:
            - 122.226.111.35/32
        lan:
            - 192.168.0.0/16
    nx:
        wlan:
            - 223.202.32.165/32
        lan:
            - 192.168.0.0/16
    tz:
        wlan:
            - 223.202.45.25/32

        lan:
            - 192.168.0.0/16
    tw:
        wlan:
            - 122.147.184.5/32
            - 122.147.184.226/32
        lan:
            - 192.168.0.0/16
    korea:
        wlan:
            - 211.55.34.78/32
            - 211.55.34.79/32
        lan:
            - 192.168.0.0/16
    jp:
        wlan:
            - 210.129.81.69/32
            - 210.129.81.70/32
        lan:
            - 172.16.24.0/24
    th:
        wlan:
            - 27.131.146.126/32
            - 27.131.146.19/32
        lan:
            - 10.66.200.0/24
    enrms:
        wlan:
            - 218.32.57.198/32
            - 218.32.57.204/32
        lan:
            - 192.168.131.0/24
    yinni:
        wlan:
            - 114.129.22.7/32
            - 114.129.22.9/32
        lan:
            - 192.168.249.0/24
    sogame:
        wlan:
            - 198.143.185.186/32
        lan:
            - 192.168.249.0/24
    vng:
        wlan:
            - 118.102.7.5/32
            - 118.102.7.59/32
        lan:
            - 10.30.27.0/24
            - 172.16.10.0/24
    wave:
        wlan:
            - 122.147.184.226/32
            - 198.23.85.140/32
        lan:
            - 10.90.13.215/32
    khyujun:
        wlan:
            - 210.242.105.143/32
            - 210.242.105.144/32
        lan:
            - 192.168.27.0/24
    khva8:
        wlan:
            - 75.126.10.69/32
        lan:
            - 10.84.230.192/26
    khyn:
        wlan:
            - 125.212.193.18/32
            - 125.212.193.19/32
        lan:
            - 10.58.56.0/24
    khmalai:
        wlan:
            - 14.192.69.116/32
            - 14.192.68.152/32
        lan:
            - 14.192.69.0/24
    mhtw:
        wlan:
            - 61.219.14.132/32
            - 61.219.14.131/32
        lan:
            - 192.168.10.0/24
    mhyn:
        wlan:                    
            - 125.212.210.235/32 
        lan:                     
            - 192.168.0.0/16
    mytg:
        wlan:
            - 27.254.37.151/32
        lan:
            - 192.168.17.0/24
    yn:
        wlan:
            - 118.69.174.201/32
            - 118.69.174.219/32
        lan:
            - 192.168.0.0/16
    myyinni:
        wlan:
            - 103.29.186.77/32
            - 103.29.186.80/32
        lan:
            - 10.0.0.0/16
    zsko:
        wlan:
            - 1.234.11.81/32
            - 175.126.104.212/32
        lan:
            - 172.19.174.0/24
    # 对不友好的Ip进行阻隔
    black:
        ips:
                

    #游戏需要对所有玩家开放的端口
    whiteport:
        ports: 443,9118,80,20001,4505,4506,5280,9130,9131
            
    #GM后台
    gm_tool:
        dport:
            122.226.109.155/32: 9131,8010,9103,9014,9132
            60.12.156.155/32: 9131,8010,9103,9014,9132
        sport:
            0.0.0.0/0 : 80,22,9103,7001,8101,9101,5280,9104,843
        
    
