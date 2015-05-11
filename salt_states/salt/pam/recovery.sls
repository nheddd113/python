{% set os=grains['os']%}
{% if os == 'Debian' %}
/etc/pam.d/common-auth:
    file.managed:
        - source: salt://pam/debian/conf/recovery/common-auth
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/common-account:
    file.managed:
        - source: salt://pam/debian/conf/recovery/common-account
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/common-session:
    file.managed:
        - source: salt://pam/debian/conf/recovery/common-session
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/common-password:
    file.managed:
        - source: salt://pam/debian/conf/recovery/common-password
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/chpasswd:
    file.managed:
        - source: salt://pam/debian/conf/recovery/chpasswd
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/common-session-noninteractive:
    file.managed:
        - source: salt://pam/debian/conf/recovery/common-session-noninteractive
        - mode: 644
        - user: root
        - group: root

/etc/nsswitch.conf:
    file.managed:
        - source: salt://pam/debian/conf/recovery/nsswitch.conf
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/sudo:
    file.managed:
        - source: salt://pam/debian/conf/recovery/pam_sudo
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/sshd:
    file.managed:
        - source: salt://pam/debian/conf/recovery/pam_sshd
        - mode: 644
        - user: root
        - group: root

{% elif os == 'CentOS' %}
/etc/nsswitch.conf:
    file.managed:
        - source: salt://pam/centos/conf/recovery/nsswitch.conf
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/password-auth-ac:
    file.managed:
        - source: salt://pam/centos/conf/recovery/password-auth-ac
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/system-auth-ac:
    file.managed:
        - source: salt://pam/centos/conf/recovery/system-auth-ac
        - mode: 644
        - user: root
        - group: root

/etc/pam.d/passwd:
    file.managed:
        - source: salt://pam/centos/conf/recovery/passwd
        - mode: 644
        - user: root
        - group: root

{% endif %}