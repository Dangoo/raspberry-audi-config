#!/bin/bash
# Update system
echo "Updating system…"
apt-get update
apt-get upgrade

# Install dependencies
echo "Installing dependencies…"

apt install --no-install-recommends build-essential git autoconf automake libtool \
    libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev \
    libplist-dev libsodium-dev libavutil-dev libavcodec-dev libavformat-dev uuid-dev libgcrypt-dev xxd

echo "Configuring sound output"

if [ -e /etc/asound.conf ]; then
    if [ -e /etc/asound.conf.old ]; then
        sudo rm -f /etc/asound.conf.old
    fi
    sudo mv /etc/asound.conf /etc/asound.conf.old
fi

cp -i asound.conf /etc

# Move to user $HOME
cd ~
echo "Changed working directory to $PWD"

# Install nqptp
echo "Installing nqptp…"

git clone https://github.com/mikebrady/nqptp.git
cd nqptp
echo "Changed working directory to $PWD"
autoreconf -fi
./configure --with-systemd-startup
make
make install

cd ~
echo "Changed working directory to $PWD"

# Start nqptp daemon
echo "Starting nqptp…"

systemctl enable nqptp
systemctl start nqptp

# Install shairport-sync
echo "Installing shairport-sync…"

git clone --branch development https://github.com/mikebrady/shairport-sync.git
cd shairport-sync
echo "Changed working directory to $PWD"
autoreconf -fi
./configure --sysconfdir=/etc --with-alsa \
    --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2
make -j
make install

cd ~
echo "Changed working directory to $PWD"

# Start shairport-sync
echo "Starting shairport-sync…"

systemctl enable shairport-sync
systemctl start shairport-sync