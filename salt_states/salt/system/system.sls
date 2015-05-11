sysinfo:
    cmd.run:
        - names:
            - cp /usr/share/zoneinfo/{{pillar['game']['timefile']}} /etc/localtime
            - /mnt/db.bak/xl/changepasswd 
{#如果时区文件存在就删除文件,并增加新的时区#}
/etc/timezone:
    file.absent
changetimezone:
    file.append:
        - makedirs: True
        - name: /etc/timezone
        - text: {{pillar['game']['timefile']}}
databak.domain.com:
    host.present:
        - ip: {{pillar['system']['databak_ip']}}
posthost:
    host.present:
        - ip: 127.0.0.1
        - names:
            - db 
            - log.db
/etc/profile:
    file.append:
        - text: 
            - HISTFILESIZE=2000
            - HISTSIZE=2000
            - HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

cleanhousename:
    file.absent:
        - name: /etc/conf/uqee/housename
/etc/conf/uqee/housename:
    file.append:
        - makedirs: True
        - text: {{pillar['game']['housename']}}

cleangamename:
    file.absent:
        - name: /etc/conf/uqee/gamename

/etc/conf/uqee/gamename:
    file.append:
        - makedirs: True
        - text: {{pillar['game']['gamename']}}

core_pattern:
    cmd.run:
        - name: echo /corefile/core.%e > /proc/sys/kernel/core_pattern
/corefile:
    file.directory:
        - makedirs: True
        - mode: 755

/etc/rc.local:
    file.managed:
        - source: salt://system/rc.local
        - mode: 755
        - user: root
        - group: root

/etc/resolv.conf:
    file.managed:
        - source: salt://system/resolv.conf
        - mode: 644
        - user: root

/etc/hosts.allow:
    file.managed:
        - source: salt://system/hosts.allow
        - user: root
        - group: root
        - mode: 644