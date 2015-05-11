{% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
postgresql-8.4:
    pkg:
        - latest
        - skip_verify: True
        - env: 
            - LC_ALL: en_US.UTF-8
    service:
        - running
        - name: postgresql
        - enable: True
        - restart: True
        - reload: True
        - watch: 
            - file: /etc/postgresql/8.4/main/postgresql.conf
            - file: /etc/postgresql/8.4/main/pg_hba.conf


/etc/postgresql/8.4/main/postgresql.conf:
    file.append:
        - text: "listen_addresses = '127.0.0.1'"
        - mode: 644



/etc/postgresql/8.4/main/pg_hba.conf:
    file.sed:
        - before: 'md5'
        - after: 'trust'
        - limit: "^host    all         all         127.0.0.1/32          "


{% endif %}