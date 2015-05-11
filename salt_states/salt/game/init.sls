include:
    - system
    {% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
    - .postgresql
    - .cron
    - .web
    - .report
    - .game
    {% if grains['player_state'] == 1 %}
    - .player_state
    {% endif %}
    - nagios
    {% if pillar['game']['housename'] == 'vng' and pillar['game']['gamename'] == 'lyingdragon' %}
    - .zabbix
    {% endif %}

    {% endif %}
    - system.updategrains
    - .after
