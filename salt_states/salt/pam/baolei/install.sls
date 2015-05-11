pam_install:
    cmd.run:
        - name: apt-get clean all 
    pkg.installed:
        - skip_verify: True
        - env: 
            - LC_ALL: en_US.UTF-8
        - pkgs:
            - ldap-utils: '=2.4.23-7.2'
            - libpam-ldap
            - libpam-cracklib
            - nslcd
            - libnss-ldapd
            - libpam0g-dev: '=1.1.1-6.1'
            - sudo-ldap
            - zlib1g-dev
            - gcc
            - libssl-dev
            - make
            - sshpass


upgrade_openssh:
    file.managed:
        - name: /tmp/openssh-6.2p2.tar.gz
        - source: salt://pam/openssh-6.2p2.tar.gz
            
    cmd.run:
        - unless: test -e /usr/local/bin/ssh
        - cwd: /tmp
        - user: root
        - name: tar xf openssh-6.2p2.tar.gz; cd openssh-6.2p2; ./configure --with-md5-passwords --sbindir=/usr/sbin --with-pam && make && make install 

