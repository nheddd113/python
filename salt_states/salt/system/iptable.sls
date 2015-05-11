open_iptable:
    cmd.run:
        - name: iptables -P INPUT ACCEPT
#清除目前已经有的.
cleand_rule:
    iptables.flush

#公网SSH白名单允许#}
{% for whiteip in pillar['iptable']['public'] %}
{{whiteip}}_ssh:   
    iptables.insert:
        - table: filter
        - position: 1
        - chain: INPUT
        - j: ACCEPT
        - s: {{ whiteip }}
        - save: True
{% endfor %}

#允许自身可以访问自己.
{% for ip in grains['ipv4'] %}
{{ip}}_self_rule:
    iptables.insert:
        - table: filter
        - position: 1
        - chain: INPUT
        - j: ACCEPT
        - s: {{ ip }}
        - save: True
{% endfor %}

#按机器房允许SSH配置 #}
{% if pillar['game']['housename']  in pillar['iptable'].keys() %}
{% set housename = pillar['game']['housename'] %}
{% for ip in pillar['iptable'][housename]['wlan'] %}
{{ip}}_{{housename}}_wlan:
    iptables.insert:
        - table: filter
        - position: 1
        - chain: INPUT
        - j: ACCEPT
        - s: {{ ip }}
        - save: True

{% endfor %}
{% for ip in pillar['iptable'][housename]['lan'] %}
{{ip}}_{{housename}}_lan:
    iptables.insert:
        - table: filter
        - position: 1
        - chain: INPUT
        - j: ACCEPT
        - s: {{ ip }}
        - save: True
{% endfor %}
{% endif %}
#对外端口
{% for port in pillar['iptable']['whiteport']['ports'] %}
whiteport_{{port}}:
    iptables.insert:
        - table: filter
        - position: 1
        - chain: INPUT
        - j: ACCEPT
        - dport: {{port}}
        - proto: tcp
        - save: True
{% endfor %}

#GM后台
{% for gm_ip,ports in pillar['iptable']['gm_tool']['dport'].items() %}
{{gm_ip}}_dport_rule:
    iptables.insert:
        - table: filter
        - position: 1
        - chain: INPUT
        - j: ACCEPT
        - s: {{gm_ip}}
        - dports: {{ports}}
        - proto: tcp
        - save: True
{% endfor %}
{% for gm_ip,ports in pillar['iptable']['gm_tool']['sport'].items() %}
{% for port in ports %}
{{gm_ip}}_{{port}}_sport_rule:
    iptables.insert:
        - table: filter
        - position: 1
        - chain: INPUT
        - j: ACCEPT
        - s: {{gm_ip}}
        - sport: {{port}}
        - proto: tcp
        - save: True
{% endfor %}
{% endfor %}
        

#拒绝其它连接#}
deny:
    iptables.append:
        - table: filter
        - chain: INPUT
        - j: REJECT
        - proto: tcp
        - save: True
    
#重启后自动加载防火墙
/etc/network/if-up.d/iptable:
    file.managed:
        - source: salt://system/iptable
        - mode: 755


        