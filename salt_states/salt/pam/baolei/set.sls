{% set basedn="dc=uqeeauth,dc=com" %}
{% set ldap_ip = pillar['system']['ldap_ip'] %}
{% if salt['uqee_chkgame.checkwlan']() %}
{% set vlan = ldap_ip.pop(0) %}
{% endif %}
/etc/nslcd.conf:
    file.managed:
        - source: salt://pam/baolei/conf/nslcd.conf
        - user: root
        - group: nslcd
        - mode: 400
        - backup: minion
        - template: jinja
        - defaults:
            ldap_server: {{pillar['system']['ldap_ip']|join(' ')}}
            basedn: {{basedn}}

/etc/nsswitch.conf:
    file.managed:
        - source: salt://pam/baolei/conf/nsswitch.conf
        - mode: 644
        - backup: minion

/etc/pam.d/common-account:
    file.managed:
        - source: salt://pam/baolei/conf/common-account
        - mode: 644
        - backup: minion

/etc/pam.d/common-password:
    file.managed:
        - source: salt://pam/baolei/conf/common-password
        - mode: 644
        - backup: minion

/etc/pam.d/common-auth:
    file.managed:
        - source: salt://pam/baolei/conf/common-auth
        - mode: 644
        - backup: minion

/etc/pam.d/common-session:
    file.managed:
        - source: salt://pam/baolei/conf/common-session
        - mode: 644
        - backup: minion

/etc/pam.d/common-session-noninteractive:
    file.managed:
        - source: salt://pam/baolei/conf/common-session-noninteractive
        - mode: 644
        - backup: minion


/etc/pam_ldap.conf:
    file.managed:
        - source: salt://pam/baolei/conf/pam_ldap.conf
        - mode: 644
        - backup: minion
        - template: jinja
        - defaults:
            ldap_server: {{pillar['system']['ldap_ip']|join(' ')}}
            basedn: {{basedn}}

/etc/ldap/check-ldap.sh:
    file.managed:
        - source: salt://pam/baolei/conf/check-ldap.sh
        - mode: 755
        - backup: minion
        - template: jinja
        - defaults:
            ldap_host: salt

/etc/default/ssh:
    file.managed:
        - source: salt://pam/baolei/conf/default_ssh
        - mode: 644
        - backup: minion
    
/etc/ssh/sshd_config:
    file.managed:
        - source: salt://pam/baolei/conf/sshd_config
        - mode: 644
        - backup: minion

/etc/sudo-ldap.conf:
    file.managed:
        - source: salt://pam/baolei/conf/sudo-ldap.conf
        - mode: 644
        - backup: minion
        - template: jinja
        - defaults:
            ldap_server: {{pillar['system']['ldap_ip']|join(' ')}}
            basedn: {{basedn}}
            

/etc/pam.d/sshd:
    file.managed:
        - source: salt://pam/baolei/conf/pam_sshd
        - mode: 644
        - backup: minion

/etc/pam.d/sudo:
    file.managed:
        - source: salt://pam/baolei/conf/pam_sudo
        - mode: 644
        - backup: minion

    
