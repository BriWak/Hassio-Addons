# sky_remote

HOME ASSISTANT CONFIGURATION

Add the following inside your Home Assistant configuration.yaml to use it :

For a Sensor to detect the state of the Sky box (Replace both of the YOUR_SKY_BOX_IP entries with the IP address of your sky box and don't set scan_interval below 300 or it can cause your sky box to freeze up):

```yaml
sensor:
  - platform: command_line
    name: sky_hd_status
    command: curl -i -s -o /dev/null -w "%{http_code}" 'http://YOUR_SKY_BOX_IP:49159/photo-viewing/start?uri=http://192.168.0.256/null.jpg' && curl 'http://YOUR_SKY_BOX_IP:49159/photo-viewing/stop'
    scan_interval: 300
```

SWITCH OPTION 1
For a simple switch to turn it on and off:

```yaml
switch:
  - platform: template
    switches:
      sky:
        friendly_name: "Sky Box"
        value_template: '{{ is_state("sensor.sky_hd_status", "200") }}'
        turn_on:
          service: hassio.addon_stdin
          data:
            addon: local_sky_remote
            input: power
        turn_off:
          service: hassio.addon_stdin
          data:
            addon: local_sky_remote
            input: power
```

SWITCH OPTION 2
Or if you want a more accurate switch that gets the correct state of the box within 5 seconds add this to your scripts.yaml:

```yaml
  power_sky_and_update:
    alias: Turn on Sky
    sequence:
      - alias: Turn Sky on
        service: switch.turn_on
        data:
          entity_id: switch.sky_hidden
      - delay: '00:00:05'
      - alias: Update sky sensor
        service: homeassistant.update_entity
        data:
          entity_id: sensor.sky_hd_status
```

and this to your configuration.yaml:

```yaml
switch:
  - platform: template
    switches:
      sky_hidden:
        friendly_name: "Sky Box"
        value_template: '{{ is_state("sensor.sky_hd_status", "200") }}'
        turn_on:
          service: hassio.addon_stdin
          data:
            addon: local_sky_remote
            input: power
        turn_off:
          service: hassio.addon_stdin
          data:
            addon: local_sky_remote
            input: power
      sky:
        friendly_name: "Sky Box"
        value_template: '{{ is_state("sensor.sky_hd_status", "200") }}'
        turn_on:
          service: script.turn_on
          entity_id: script.power_sky_and_update
        turn_off:
          service: script.turn_on
          entity_id: script.power_sky_and_update
```

you can also add this to your customize.yaml to hide the sky_hidden switch from the interface:

```yaml
switch.sky_hidden:
  hidden: true
```
