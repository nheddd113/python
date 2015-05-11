/usr/local/nagios/libexec/check_lyingdragon:
    cmd.run:
        - onlyif: test -f /usr/local/nagios/libexec/check_lyingdragon
        - name: cp /mnt/db.bak/xl/python_xl/check_lyingdragon /usr/local/nagios/libexec/check_lyingdragon