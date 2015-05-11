    {% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
{% if grains['player_state']  == 1 %}

/root/workspace/foxlog/player_state:
    cmd.run:
        - onlyif: pgrep player_state
        - name: kill -9 $(pgrep player_state)

clean_playerstate:
    postgres_database.absent:
        - name: game_log
        - port: 5432
playerstate:
    postgres_database.present:
        - name: game_log
        - port: 5432

/etc/init.d/foxlog:
    file.managed:
        - source: salt://game/foxlog
        - mode: 755
        - user: root
foxlog:
    service:
        - running
        - enable: True
        - watch:
            - file: /etc/init.d/foxlog



{% endif %}
{% endif %}