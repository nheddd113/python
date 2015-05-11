/usr/local/nagios/libexec/check_lyingdragon:
    file.managed:
        - source: salt://nagios/check_lyingdragon
        - user: nagios
        - mode: 755