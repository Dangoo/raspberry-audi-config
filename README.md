# raspberry-audi-config
Template for setting up a Raspberry Pi with Shairport-Sync

## Setting up equalizer

### Adding `asound.conf`
```bash
cp -i asound.conf /etc
```

### Configure shairport-sync user
```
# /etc/systemd/system/shairport-sync.service
[Service]
User=pi
Group=pi
```

### Configure equalizer levels

- Either by using the UI
  ```bash
  alsamixer -D equal
  ```
- or by providing a preset per channel
  ```bash
  # Sets channel 31 Hz to 85%
  amixer -D equal cset numid=1 85
  ```
  https://wiki.cyberleo.net/wiki/KnowledgeBase/AlsaEqual

### Setup I2s Speaker Bonnet (optional)

Run shell script from [Adafruits guide](https://learn.adafruit.com/adafruit-speaker-bonnet-for-raspberry-pi/raspberry-pi-usage):
```bash
curl -sS https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/i2samp.sh | bash
```

If you have trouble with the "popping"  helper `aplay` try to add a user to service config:

```
# /etc/systemd/system/aplay.service
[Service]
User=pi
Group=pi
```
