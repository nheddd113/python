include:
{% if grains['os'] == 'Debian' %}
    - .install
    - .set
    - .service
{% elif grains['os'] == 'CentOS' %}

{% endif %}