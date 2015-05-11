{% if pillar['game']['gamename'] in pillar['game']['gamelist'] %}
cleangame:
    pkg.purged:
        - pkgs:
            - {{grains['gamepackage']}}
{{grains['gamepackage']}}:
    pkg:
        - latest
        - skip_verify: True
{% endif %}