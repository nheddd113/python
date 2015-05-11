python-pygresql:
    pkg.latest:
        - skip_verify: True

python-psutil:
    pkg.latest:
        - skip_verify: True

/usr/share/pyshared/salt/returners/postgres.py:
    file.managed:
        - source: salt://conf/postgres.py

salt_database_remove:
    postgres_database.absent:
        - name: salt
        - user: postgres
        - port: 5433

salt_database_create:
    postgres_database.present:
        - name: salt
        - user: postgres
        - port: 5433

/tmp/salt.schema:
    file.managed:
        - source: salt://conf/salt.schema
    cmd.run:
        - name: psql -h db -U postgres salt -f /tmp/salt.schema

        