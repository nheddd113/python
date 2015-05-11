{% set basedn="dc=uqeeauth,dc=com" %}
{% set ldap_ip = pillar['system']['ldap_ip'] %}
{% if salt['uqee_chkgame.checkwlan']() %}
{% set vlan = ldap_ip.pop(0) %}
{% endif %}
/etc/nslcd.conf:
    file.managed:
        - source: salt://pam/centos/conf/nslcd.conf
        - user: root
        - group: root
        - mode: 600
        - backup: minion
        - template: jinja
        - defaults:
            ldap_server: {{pillar['system']['ldap_ip']|join(' ')}}
            basedn: {{basedn}}
            

/etc/nsswitch.conf:
    file.managed:
        - source: salt://pam/centos/conf/nsswitch.conf
        - mode: 644
        - backup: minion

/etc/pam_ldap.conf:
    file.managed:
        - source: salt://pam/centos/conf/pam_ldap.conf
        - mode: 644
        - backup: minion
        - template: jinja
        - defaults:
            ldap_server: {{pillar['system']['ldap_ip']|join(' ')}}
            basedn: {{basedn}}

/etc/ssh/sshd_config:
    file.managed:
        - source: salt://pam/centos/conf/sshd_config
        - mode: 600
        - backup: minion

/etc/sudo-ldap.conf:
    file.managed:
        - source: salt://pam/centos/conf/sudo-ldap.conf
        - mode: 640
        - backup: minion
        - template: jinja
        - defaults:
            ldap_server: {{pillar['system']['ldap_ip']|join(' ')}}
            basedn: {{basedn}}

    
/etc/pam.d/password-auth-ac:
    file.managed:
        - source: salt://pam/centos/conf/password-auth-ac
        - backup: minion

/etc/pam.d/system-auth-ac:
    file.managed:
        - source: salt://pam/centos/conf/system-auth-ac
        - backup: minion

/etc/pam.d/passwd:
    file.managed:
        - source: salt://pam/centos/conf/passwd
        - backup: minion
