{% if grains['os'] == 'Debian' %}
/usr/local/etc/ssh_config:
    file.append:
        - text: 
            - StrictHostKeyChecking no
            - UserKnownHostsFile /dev/null
/etc/pam.d/chpasswd:
    file.managed:
        - source: salt://pam/debian/conf/chpasswd
        - mode: 644
        - backup: minion

/etc/init.d/nrpe:
    file.managed:
        - source: salt://nagios/nagios.sh
        - mode: 755
    cmd.run:
        - name: insserv -d nrpe ; invoke-rc.d nrpe restart
uqee:
    service.dead:
        - enable: True
    cmd.run:
        - name: insserv -r uqee ; rm -rf /etc/init.d/uqee

        

{% endif %}