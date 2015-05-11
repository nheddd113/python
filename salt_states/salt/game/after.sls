{% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
{% if pillar['game']['housename'] == 'vng' %}
vn.wlymanager.uqee.com:
    host.present:
        - ip: 10.30.27.59
ssh_id_dsa:
    cmd.run:
        - name: cp /mnt/db.bak/test/id_dsa /root/.ssh
    file.managed:
        - name: /root/.ssh/id_dsa
        - mode: 600
/etc/resolv.conf_1:
    file.append:
        - name: /etc/resolv.conf
        - text:
            - nameserver 118.102.5.136
            - nameserver 103.23.156.6
{% endif %}

restart_server:
    cmd.run:
        - names: 
            {% if pillar['game']['gamename'] == 'lyingdragon' %}
            - invoke-rc.d tomcat restart
            {% endif %}
            {% if grains['player_state'] == 1 %}
            - invoke-rc.d foxlog restart
            {% endif %}
            - invoke-rc.d apache2 restart
            - invoke-rc.d nrpe restart

{% endif %}