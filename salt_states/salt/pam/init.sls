include:
    {% if grains['os'] == 'Debian' %}
    - .debian.install 
    - .debian.set
    - .debian.service
    {% elif grains['os'] == 'CentOS' %}
    - .centos.install 
    - .centos.set
    - .centos.service
    {% endif %}