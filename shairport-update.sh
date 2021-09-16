cd ~

# Update system
echo "Updating system…"
apt-get update
apt-get upgrade

# Install nqptp
echo "Updating nqptp…"

cd ~/nqptp/

git fetch

if $(git rev-parse HEAD) != $(git rev-parse @{u}); then
    git pull
    autoreconf -fi
    ./configure
    make
    make install
    echo "Updated successfully"

else
    echo "Already up-to-date"
fi

# Restart nqptp daemon
echo "Restarting nqptp…"

systemctl restart nqptp

# Install shairport-sync
echo "Updating shairport-sync…"

cd ~/shairport-sync/

if $(git rev-parse HEAD) != $(git rev-parse @{u}); then
    git pull
    autoreconf -fi
    ./configure --sysconfdir=/etc --with-alsa \
        --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-dbus-interface --with-airplay-2
    make -j
    make install
    echo "Updated successfully"

else
    echo "Already up-to-date"
fi

# Restart shairport-sync
echo "Restarting shairport-sync…"

systemctl restart shairport-sync

cd ~