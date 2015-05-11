/etc/init.d/nrpe:
    file.managed:
        - source: salt://nagios/nagios.sh
        - mode: 755
nrpe:
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /usr/local/nagios/etc/nrpe.cfg


/usr/local/nagios/etc/nrpe.cfg:
    file.managed:
        - source: salt://nagios/nrpe.cfg
        - template: jinja
        - defaults:
            server_ip: {{ pillar['nrpe']['server_ip'] }}
    