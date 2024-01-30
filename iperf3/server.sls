{{ tpldot }}.package:
  pkg.installed:
    - name: iperf3

{{ tpldot }}.user:
  user.present:
    - name: iperf3
    - system: True
    - createhome: False
    - shell: /sbin/nologin

{{ tpldot }}.systemd-reload:
  cmd.run:
    - name: systemctl --system daemon-reload
    - onchanges:
      - file: /etc/systemd/system/iperf3.service

{{ tpldot }}.iperf3:
  service.running:
    - name: iperf3
    - enable: true
    - watch:
      - file: /etc/systemd/system/iperf3.service

/etc/systemd/system/iperf3.service:
  file.managed:
    - source: salt://{{ tpldir }}/files/etc/systemd/system/iperf3.service
    - require:
      - user: {{ tpldot }}.user
      - pkg: {{ tpldot }}.package
