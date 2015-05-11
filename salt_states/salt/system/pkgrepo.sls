  {% set master = grains['master'] %}
debian:
  pkgrepo.managed:
    - name: "deb http://{{master}}/debian sid main"
    - file: /etc/apt/sources.list.d/uqee.list
wly:
  pkgrepo.managed:
    - name: "deb http://{{master}}/wly sid main"
    - file: /etc/apt/sources.list.d/uqee.list
dell:
  pkgrepo.managed:
    - name: "deb http://{{master}}/dell sid main"
    - file: /etc/apt/sources.list.d/uqee.list


salt:
  pkgrepo.managed:
    - name: "deb http://{{master}}/salt sid main"
    - file: /etc/apt/sources.list.d/uqee.list

  
      