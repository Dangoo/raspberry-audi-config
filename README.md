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



