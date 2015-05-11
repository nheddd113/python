/root/.ssh/gongyao_keys:
    file.absent
        # - makedirs: True
        # - source: salt://system/baolei/id_dsa.pub
        # - user: root
        # - group: root
        # - mode: 600

/etc/default/unison_key:
    file.managed:
        - makedirs: True
        - source: salt://system/baolei/id_dsa
        - user: root
        - group: root
        - mode: 600
    