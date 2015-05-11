sshd:
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/ssh/sshd_config

nslcd:
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/nslcd.conf


nscd:
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/nsswitch.conf

##帐号处理

nagios:
    user.present:
        - shell: /bin/nologin
