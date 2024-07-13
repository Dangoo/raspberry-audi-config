#!/bin/bash
cd ~

# Update system
echo "Updating system…"
sudo apt-get update
sudo apt-get upgrade -y

# Install nqptp
echo "Updating nqptp…"

cd -- "$(find ~ -name nqptp -type d)"

git fetch

CURRENT_NQPTP_TAG=$(git describe --tags --abbrev=0)
NEW_NQPTP_TAG=$(git tag -l --sort=v:refname | grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+$' | tail -1)

if dpkg --compare-versions $CURRENT_NQPTP_TAG "lt" $NEW_NQPTP_TAG; then
    echo "Updating nqptp from ${CURRENT_NQPTP_TAG} to ${NEW_NQPTP_TAG}"
    git pull
    autoreconf -fi
    ./configure --with-systemd-startup
    sudo make
    sudo make install
    echo "Updated successfully"

else
    echo "Already up-to-date"
fi

# Restart nqptp daemon
echo "Restarting nqptp…"

sudo systemctl daemon-reload
sudo systemctl restart nqptp

# Install shairport-sync
echo "Updating shairport-sync…"

cd -- "$(find ~ -name shairport-sync -type d)"

git fetch

CURRENT_SHAIRPORT_TAG=$(git describe --tags --abbrev=0)
NEW_SHAIRPORT_TAG=$(git tag -l --sort=v:refname | grep -o '^[0-9]\+\.[0-9]\+\.[0-9]\+$' | tail -1)

if dpkg --compare-versions $CURRENT_SHAIRPORT_TAG "lt" $NEW_SHAIRPORT_TAG; then
    echo "Updating shairport-sync from ${CURRENT_SHAIRPORT_TAG} to ${NEW_SHAIRPORT_TAG}"
    git pull
    autoreconf -fi
    ./configure --sysconfdir=/etc --with-alsa \
        --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2
    sudo make -j
    sudo make install
    echo "Updated successfully"

else
    echo "Already up-to-date"
fi

# Restart shairport-sync
echo "Restarting shairport-sync…"

sudo systemctl daemon-reload
sudo systemctl restart shairport-sync

cd ~
