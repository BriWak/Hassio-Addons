# Sky HD Remote

### HOME ASSISTANT CONFIGURATION

Add the repository in Home Assistant using the add-on store in the Hass.io menu and and Install the Sky HD Remote addon.

Once it has installed, update the sky_ip value in the config section on that page to the IP address of your sky box and hit Save.

Take a note of the URL while you're in the Sky HD Remote addon because everything after the last / is the addon name - it *should* always be **e71ec315_sky_remote** but check it to be sure.

Then add the following inside your Home Assistant **configuration.yaml** and then restart Home Assistant to use it :


#### ON/OFF SENSOR
For a Sensor to detect the state of the Sky box add the following, replacing both of the YOUR_SKY_BOX_IP entries with the IP address of your sky box and don't set scan_interval below 300 (5 minutes) or it can cause your sky box to freeze up:

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
            addon: e71ec315_sky_remote
            input: power
        turn_off:
          service: hassio.addon_stdin
          data:
            addon: e71ec315_sky_remote
            input: power
```

#### SWITCH OPTION 2

Or if you want a more accurate switch that gets the correct state of the box within 5 seconds of toggling the switch, add this to your configuration.yaml:

```yaml
switch:
  - platform: template
    switches:
      sky:
        friendly_name: "Sky Box"
        value_template: '{{ is_state("sensor.sky_hd_status", "200") }}'
        turn_on:
          - service: hassio.addon_stdin
            data:
              addon: e71ec315_sky_remote
              input: power
          - delay: '00:00:05'
          - service: homeassistant.update_entity
            data:
              entity_id: sensor.sky_hd_status
        turn_off:
          - service: hassio.addon_stdin
            data:
              addon: e71ec315_sky_remote
              input: power
          - delay: '00:00:05'
          - service: homeassistant.update_entity
            data:
              entity_id: sensor.sky_hd_status
```

#### Controlling a Sky TV box

The remote commands you issue to the Sky Box are controlled by the `input:` command directly below `addon: e71ec315_sky_remote`. You can issue single commands such as:

###### Turn the box on / off
```
input: power
```

or queue multiple commands by leaving a space between each command, such as:

###### Channel up, pause, show info
```
input: channelup pause i
```

###### Change channel to 101
```
input: 1 0 1
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
