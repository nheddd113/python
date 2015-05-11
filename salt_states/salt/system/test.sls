{% if salt['test.ping']() == True %}
/etc/test.txt:
    a.present:
        - ip: this is a test
{% endif %}