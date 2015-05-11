nslcd:
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/nsswitch.conf
            - file: /etc/nslcd.conf
            - file: /etc/sudo-ldap.conf
            - file: /etc/pam_ldap.conf

ssh:
    service:
        - running
        - enable: True
        - restart: True
        - watch:
             - file: /etc/default/ssh
             - file: /etc/ssh/sshd_config

nscd:
    service: 
        - dead
        - disabled: True
        - restart: False

nagios:
    user.present:
        - shell: /bin/nologin
