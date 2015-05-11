/usr/local/nagios/libexec/check_databak.py:
    file.managed:
        - source: salt://nagios/check_databak.py
        - user: nagios
        - mode: 755