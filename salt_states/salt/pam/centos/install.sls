pam_install:
    cmd.run:
        - name: rm -rf /etc/yum.repos.d/* &&  yum clean all && yum makecache
    file.managed:
        - source: salt://pam/centos/conf/salt.repo
        - name: /etc/yum.repos.d/salt.repo
    pkg.installed:
        - skip_verify: True
        - env: 
            - LC_ALL: en_US.UTF-8
        - pkgs:
            - openldap-clients.x86_64
            - pam_ldap.x86_64
            - sudo 
            - nss-pam-ldapd
            - make 
            - libgcc

            