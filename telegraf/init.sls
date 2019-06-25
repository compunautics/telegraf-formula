{% from "telegraf/map.jinja" import telegraf with context %}

influxdata_repo:
  pkgrepo.managed:
    - humanname: Influxdata repo
    - name: {{ telegraf.pkg_repo }}
    - key_url: https://repos.influxdata.com/influxdb.key
    - file: /etc/apt/sources.list.d/influxdata.list
    - require_in:
      - pkg: telegraf

telegraf_pkg:
  pkg.installed:
    - name: telegraf

telegraf_conf:
  file.managed:
    - name: /etc/telegraf/telegraf.conf
    - source: salt://telegraf/templates/telegraf.conf
    - template: jinja
    - user: telegraf
    - group: telegraf
    - mode: 0640
    
telegraf_dir:
  file.directory:
    - name: /etc/telegraf
    - user: telegraf
    - group: telegraf
    - mode: 0750

telegraf_checks_dir:
  file.directory:
    - name: /etc/telegraf/telegraf.d/checks
    - user: telegraf
    - group: telegraf
    - mode: 0700

telegraf_service:
  service.running:
    - name: telegraf
    - enable: True
    - watch:
      - file: telegraf_conf
    - require:
      - pkg: telegraf
