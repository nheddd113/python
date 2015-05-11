{% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
createreport:
    cmd.run:
        - unless: test -d /var/lib/postgresql/battlereport/report
        - name: "pg_createcluster 8.4 report -D /var/lib/postgresql/battlereport/report"
        - require:
            - file: /var/lib/postgresql/battlereport

        
/var/lib/postgresql/battlereport:
    file.directory:
        - user: postgres
        - group: postgres
        - dir_mode: 755
        - file_mode: 644
        - makedirs: True

/etc/postgresql/8.4/report/postgresql.conf:
    file.append:
        - text: "listen_addresses = '127.0.0.1'"
        - mode: 644

/etc/postgresql/8.4/report/pg_hba.conf:
    file.sed:
        - before: 'md5'
        - after: 'trust'
        - limit: "^host    all         all         127.0.0.1/32          "
        - mode: 644
restart:
    cmd.run:
        - name: invoke-rc.d postgresql restart


game_log:
    postgres_database.present:
        - db_port: 5433
        - db_user: postgres

battle_report:
    postgres_database.present:
        - db_port: 5433
        
{% endif %}    
