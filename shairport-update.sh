cd ~

# Update system
echo "Updating system…"
sudo apt-get update
sudo apt-get upgrade

# Install nqptp
echo "Updating nqptp…"

cd -- "$(find ~ -name nqptp -type d)"

git fetch

if [[ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]]; then
    git pull
    autoreconf -fi
    ./configure
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

if [[ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]]; then
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