{% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
include:
    - .nagios
{% endif %}