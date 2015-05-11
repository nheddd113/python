/etc/default/mongodb.conf:
    file.managed:
        - source: salt://game/mongodb.conf
make_mongo_dir:
    cmd.run:
        - unless: test -d /var/lib/mongodb/data
        - names:
            - mkdir -p /var/lib/mongodb/data
            - mkdir -p /var/log/mongodb/

/etc/init.d/mongodb:
    file.managed:
        - source: salt://game/mongodb
        - mode: 755

install_mongodb:
    file.managed:
        - name: /tmp/mongodb_server.tar.gz
        - source: salt://game/mongodb-linux-x86_64-2.4.8.tgz
    cmd.run:
        - unless: test -d /var/lib/mongodb/bin
        - name: tar xf /tmp/mongodb_server.tar.gz && cp -r mongodb-linux-x86_64-2.4.8/bin /var/lib/mongodb/ && rm -rf /tmp/mongodb*
        - cwd: /tmp

python-pymongo:
    pkg.installed:
        - skip_verify: True
        - env: 
            - LC_ALL: en_US.UTF-8
mongodb:
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/default/mongodb.conf
            - file: /etc/init.d/mongodb

/etc/profile:
    file.append:
        - text: PATH=$PATH:/var/lib/mongodb/bin
    cmd.wait:
        - watch:
            - file: /etc/profile
        - name: source /etc/profile

add_mongo_user_admin:
    mongodb_user.present:
        - name: admin
        - passwd: "soidc..123"
        - host: 127.0.0.1
        - port: 27017
        - user: admin
        - password: "soidc..123"

add_mongo_user_card:
    mongodb_user.present:
        - name: admin
        - passwd: "soidc..123"
        - host: 127.0.0.1
        - port: 27017
        - database: card
        - user: admin
        - password: "soidc..123"
