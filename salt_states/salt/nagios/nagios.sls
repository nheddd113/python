nagios:
    pkg:
        - latest
        - skip_verify: True
    service:
        - running
        - name: nrpe
        - enable: True
        - restart: True
        - watch:
            - file: /usr/local/nagios/etc/nrpe.cfg
            - file: /etc/init.d/nrpe

/usr/local/nagios/etc/nrpe.cfg:
    file.managed:
        - source: salt://nagios/nrpe.cfg
        - user: root
        - group: root
        - mode: 644
        - template: jinja
        - defaults:
            server_ip: {{ pillar['nrpe']['server_ip'] }}
/etc/init.d/nrpe:
    file.managed:
        - source: salt://nagios/nagios.sh
        - user: root
        - group: root
        - mode: 755
/etc/snmp/snmpd.conf:
    file.managed:
        - source: salt://nagios/snmpd.conf
{% for id in pillar['nrpe']['cacti'] %}
{{id}}:
    file.append:
        - name: /etc/snmp/snmpd.conf
        - text: rocommunity uqee   {{id}}
        - watch_in:
            - service: snmpd

{% endfor %}

{% for ip in grains['ipv4'] %}
{{ip}}:
    file.append:
        - name: /etc/snmp/snmpd.conf
        - text: agentAddress udp:{{ip}}:161
        - watch_in:
            - service: snmpd
{% endfor %}


rocomm:
    file.append:
        - name: /etc/snmp/snmpd.conf
        - text: rocommunity soidc2011 localhost
snmpd:
    pkg:
        - latest
    service:
        - running



restart snmp:
    cmd.run:
        - name: invoke-rc.d snmpd restart
        - watch:
            - pkg: snmpd

/usr/local/nagios/libexec/check_databak.py:
    file.managed:
        - source: salt://nagios/check_databak.py
        - mode: 755

/usr/local/nagios/libexec/check_lyingdragon:
    file.managed:
        - source: salt://nagios/check_lyingdragon
        - mode: 755

/usr/local/nagios/libexec/check_kherr.sh:
    file.managed:
        - source: salt://nagios/check_kherr.sh
        - mode: 755
/usr/local/nagios/libexec/check_salt:
    file.managed:
        - source: salt://nagios/check_salt
        - mode: 755

/etc/sudoers:
    file.append:
        - text: nagios ALL=NOPASSWD:ALL