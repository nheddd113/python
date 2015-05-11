    {% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
{% if pillar['game']['gamename'] == 'lyingdragon' %}
install_tomcat:
    cmd.run:
        - name: cp /mnt/db.bak/xl/bins/wly/apache-tomcat-7.0.20.tar.gz /tmp && tar xf apache-tomcat-7.0.20.tar.gz && rm -rf /usr/local/tomcat && mv apache-tomcat-7.0.20/ /usr/local/tomcat
        - cwd: /tmp
        - user: root
    file.managed:
        - name: /etc/init.d/tomcat
        - source: salt://game/wly/tomcat
        - mode: 755
tomcat:
    service:
        - name: tomcat
        - running
        - enable: True


java:
    cmd.run:
        - cwd: /tmp
        - user: root
        - name: cp /mnt/db.bak/xl/bins/wly/jre6.bin /tmp/ && ./jre6.bin > /dev/null 
    file.append:
        - name: /etc/profile
        - text:
            - export JAVA_HOME=/usr/lib/jre6
            - export PATH=$PATH:$JAVA_HOME/bin
            - export CLASSPATH=.$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:.
/usr/lib/jre6:
    file.directory:
        - makedirs: True
        - mode: 755
        - user: root
    cmd.run:
        - onlyif: test -d /usr/lib/jre6
        - name: rm -rf /usr/lib/jre6/* && cp -r  /tmp/jre1.6.0_26/* /usr/lib/jre6/ && rm -rf /tmp/jre1.6.0_26
            
/usr/local/tomcat/conf/server.xml:
    file.managed:
        - source: salt://game/wly/server.xml
        - makedirs: True
        - watch_in:
            - pkg: tomcat

/mnt/db.bak/xl/bins/wly/install.sh:
    file.exists 


/etc/apache2/sites-enable/*:
    cmd.run:
        - names: 
            - rm -rf /etc/apache2/sites-enabled/*
apache2:
    pkg:
        - latest
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/apache2/apache2.conf
            {% if grains['ssl'] == 1 %}
            - file: /etc/apache2/sites-available/wly_ssl
            {% endif%}
            - file: /etc/apache2/sites-available/wly
            - file: /etc/apache2/httpd.conf
            - file: /etc/apache2/workers.properties
            - file: /etc/apache2/ports.conf
    cmd.run:
        - names:
            - a2enmod auth_sys_group
            - a2enmod auth_pam
            

/etc/apache2/ports.conf:
    file.managed:
        - source: salt://game/wly/ports.conf

/etc/apache2/workers.properties:
    file.managed:
        - source: salt://game/wly/workers.properties

/etc/apache2/apache2.conf:
    file.managed:
        - source: salt://game/wly/apache2.conf
/etc/apache2/sites-available/wly:
    file.managed:
        - source: salt://game/wly/wly.conf
    cmd.run:
        - unless: test -L /etc/apache2/sites-enabled/wly
        - name: a2dissite default &&  a2ensite {{pillar['game']['sitename'][pillar['game']['gamename']]}} && service apache2 restart 

{% if grains['ssl'] == 1%}
/etc/apache2/sites-available/wly_ssl:
    file.managed:
        - source: salt://game/wly/wly_ssl.conf
    cmd.run:
        - unless: test -L /etc/apache2/sites-enabled/wly_ssl
        - name:  a2dissite default &&  a2ensite {{pillar['game']['sitename'][pillar['game']['gamename']]}}_ssl && service apache2 restart && cp /mnt/db.bak/test/newkey_efunfun/* /home/soidc/ && a2enmod ssl

{% endif %}

/etc/apache2/httpd.conf:
    file.managed:
        - source: salt://game/wly/httpd.conf


{% else %}
{#这里开始是除卧龙吟之外的其它游戏#}
    {% if pillar['game']['gamename'] in pillar['game']['gameweb'] %}
apache2:
    pkg:
        - latest
    service:
        - running
        - enable: True
        - restart: True
        - watch:
            - file: /etc/apache2/sites-available/{{pillar['game']['sitename'][pillar['game']['gamename']]}}
            - file: /etc/apache2/apache2.conf
            - file: /etc/apache2/httpd.conf
/etc/apache2/sites-enable/*:
    cmd.run:
        - names: 
            - rm -rf /etc/apache2/sites-enabled/*
    
/etc/apache2/apache2.conf:
    file.managed:
        - source: salt://game/wly/apache2.conf
/etc/apache2/httpd.conf:
    file.append:
        - makedirs: True
        - text: ServerName 127.0.0.1
/home/soidc:
    file.directory:
        - makedirs: True
        - mode: 755

/etc/apache2/sites-available/{{pillar['game']['sitename'][pillar['game']['gamename']]}}:
    file.managed:
        - source: salt://game/webconf/{{pillar['game']['sitename'][pillar['game']['gamename']]}}
    cmd.run:
        - name:  a2dissite default &&  a2ensite {{pillar['game']['sitename'][pillar['game']['gamename']]}} && service apache2 restart
    {% endif %}
{% endif %}

{% endif %}