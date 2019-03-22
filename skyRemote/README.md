# sky_remote

### HOME ASSISTANT CONFIGURATION

Download all files and place in your local Addon directory. Install it in Home Assistant using the add-on store in the Hass.io menu and once it has installed update the sky_ip value in the config section on that page to the IP address of your sky box and hit Save.

Then add the following inside your Home Assistant configuration.yaml (and then restart Home Assistant) to use it :

For a Sensor to detect the state of the Sky box (Replace both of the YOUR_SKY_BOX_IP entries with the IP address of your sky box and don't set scan_interval below 300 or it can cause your sky box to freeze up):

```yaml
sensor:
  - platform: command_line
    name: sky_hd_status
    command: curl -i -s -o /dev/null -w "%{http_code}" 'http://YOUR_SKY_BOX_IP:49159/photo-viewing/start?uri=http://192.168.0.256/null.jpg' && curl 'http://YOUR_SKY_BOX_IP:49159/photo-viewing/stop'
    scan_interval: 300
```

#### SWITCH OPTION 1

For a simple switch to turn it on and off that updates the state of the switch every 5 minutes:

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

#### SWITCH OPTION 2

Or if you want a more accurate switch that gets the correct state of the box within 5 seconds of toggling the switch, add this to your scripts.yaml:

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

you can also add this to your customize.yaml to hide the sky_hidden switch and the script from the interface:

```yaml
switch.sky_hidden:
  hidden: true
script.turn_on_sky_and_update:
  hidden: true
```

#### Remote control commands

These are the commands you can use as inputs for the switch:

`sky` `power`

`tvguide` or `home` `boxoffice` `services` or `search` `interactive` or `sidebar`

`up` `down` `left` `right` `select`

`channelup` `channeldown` `i`

`backup` or `dismiss` `text` `help`

`play` `pause` `rewind` `fastforward` `stop` `record`

`red` `green` `yellow` `blue`

`0` `1` `2` `3` `4` `5` `6` `7` `8` `9`
