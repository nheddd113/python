{% if pillar['game']['housename'] == 'vng' and pillar['game']['gamename'] == 'lyingdragon' %}
{% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
zabbix-agent:
    pkg:
        - latest
        - skip_verify: True
    service:
        - running
        - restart: True
        - enable: True
        - watch:
            - file: /etc/zabbix/vng
            - file: /etc/zabbix/vng/iostat.sh
            - file: /etc/zabbix/vng/mondiskio
            - file: /etc/zabbix/vng/zabbix_get_tcpcon.sh
/etc/zabbix/vng:
    file.directory:
        - makedirs: True
        - mode: 755
        - user: zabbix
        - group: zabbix
/etc/zabbix/vng/iostat.sh_1:
    file.managed:
        - name: /etc/zabbix/vng/iostat.sh
        - source: salt://game/vng/iostat.sh
        - mode: 755
        - user: zabbix
        - group: zabbix

/etc/zabbix/vng/mondiskio:
    file.managed:
        - source: salt://game/vng/mondiskio
        - mode: 755
        - user: zabbix
        - group: zabbix
/etc/zabbix/vng/zabbix_get_tcpcon.sh:
    file.managed:
        - source: salt://game/vng/zabbix_get_tcpcon.sh
        - mode: 755
        - user: zabbix
        - group: zabbix
{% endif %}        
{% endif %}