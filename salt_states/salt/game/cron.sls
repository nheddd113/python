    {% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
{% set gamename = pillar['game']['gamename'] %}

{% if gamename == 'legendary' %}
back4:
    cron.present:
        - name: /mnt/db.bak/xl/autobak.sh
        - user: root
        - hour: 4
        - minute: 59
        - identifier: 4 clock 
back12:
    cron.present:
        - name: /mnt/db.bak/xl/autobak.sh
        - user: root
        - hour: 12
        - minute: 0
        - identifier: 12 clock 
back18:
    cron.present:
        - name: /mnt/db.bak/xl/autobak.sh
        - user: root
        - hour: 18
        - minute: 0
        - identifier: 18 clock 

back23:
    cron.present:
        - name: /mnt/db.bak/xl/autobak.sh
        - user: root
        - hour: 23
        - minute: 59
        - identifier: 23 clock 

{% else %}
back1:
    cron.present:
        - name: /mnt/db.bak/xl/autobak.sh
        - user: root
        - hour: 1
        - minute: 10
        - identifier: 1 clock 

back9:
    cron.present:
        - name: /mnt/db.bak/xl/autobak.sh
        - user: root
        - hour: 9
        - minute: 10   
        - identifier: 9 clock 
 
back17:
    cron.present:
        - name: /mnt/db.bak/xl/autobak.sh
        - user: root
        - hour: 17
        - minute: 10
        - identifier: 17 clock 

{% endif %}

{% if gamename == 'dreamback' %}
khbd_delete_log:
    cron.present:
        - name: /mnt/db.bak/xl/delete_khbdlog.sh
        - user: root
        - hour: 2
        - minute: 0
        - identifier: DELETE KHBD LOG
{% endif %}

/usr/sbin/ntpdate asia.pool.ntp.org >> /var/log/ntpdate.log 2>&1:
  cron.present:
    - identifier: "verify datetime from wlan "
    - user: root
    - minute: 0

/usr/sbin/ntpdate {{pillar['system']['ip']}} >> /var/log/ntpdate.log 2>&1:
  cron.present:
    - identifier: "verify datetime from vlan "
    - user: root
    - minute: 0

{% if pillar['game']['housename'] == 'vng' %}
/mnt/db.bak/xl/vng_log.sh >> /var/log/lyingdragon/vng_log 2>&1:
  cron.present:
  - identifier: "tranfor log to other server"
  - user: root
  - minute: 0
  - hour: 4
{% endif %}

{% if pillar['game']['housename'] == 'jp' %}
/mnt/db.bak/xl/tw_log.sh jp >> /var/log/japan_log 2>&1:
  cron.present:
  - identifier: "tranfor log to other server"
  - user: root
  - minute: 0
  - hour: 4
{% endif %}

{% if pillar['game']['housename'] == 'tw' %}
/mnt/db.bak/xl/tw_log.sh >> /var/log/japan_log 2>&1:
  cron.present:
  - identifier: "tranfor log to other server"
  - user: root
  - minute: 0
  - hour: 4
/mnt/db.bak/xl/tarlog.sh:
  cron.present:
  - identifier: "gzip log"
  - user: root
  - minute: 0
  - hour: 4
/root/.ssh/id_dsa:
  file.managed:
  - source: salt://game/efunfun/id_dsa
  - mode: 600
{% endif %}


{% if pillar['game']['housename'] == 'vng'  %}
/mnt/db.bak/xl/vng_update_data.py >> /var/log/vng_update_data.log 2>&1:
  cron.present:
  - identifier: "vng update role info"
  - user: root
  - minute: 0
  - hour: 1

/mnt/db.bak/xl/tencent.sh >> /var/log/lyingdragon/tencent_log 2>&1:
  cron.present:
  - identifier: "vng log for tencent"
  - user: root
  - minute: 0
  - hour: 4

/etc/zabbix/vng/iostat.sh:
  cron.present:
  - identifier: "vng zabbix"
  - user: root
  - minute: "*/5"
/root/.ssh/id_dsa:
    file.managed:
        - source: salt://game/vng/id_dsa
        - mode: 600
{% endif %}


{% set filelist = ['taiwan','beijin','enrms','huanguo','jinhua','malai','mytg','nanxun','pubnet','riben','sogame','taiguo','tongzhou','vava8','waves','yinni','yuenan'] %}
{% for file in filelist %}
/etc/cron.d/cron_time_{{file}}:
  file.absent
{% endfor %}

cron:
  pkg.installed:
    - name: cron
  service:
    - running
    - reload: True
    - watch:
      - file: /etc/cron.d/*
{% endif %}