cd ~

# Update system
echo "Updating system…"
apt-get update
apt-get upgrade

# Install nqptp
echo "Updating nqptp…"

cd nqptp
git pull
autoreconf -fi
./configure
make
make install
cd ~

# Restart nqptp daemon
echo "Starting nqptp…"

systemctl restart nqptp

# Install shairport-sync
echo "Updating shairport-sync…"

cd shairport-sync
git pull
autoreconf -fi
./configure --sysconfdir=/etc --with-alsa \
    --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-dbus-interface --with-airplay-2
make -j
make install

cd ~

# Restart shairport-sync
echo "Starting shairport-sync…"

systemctl restart shairport-sync
