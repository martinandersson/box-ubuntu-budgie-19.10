# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x



# Vagrant will crash if he tries to install stuff on the machine such as Pip and
# Ansible while an update or installation process is already running. One would
# think he could have just waited until the active process completes. Alas that
# is not the case.
# 
# We could disable the system's update timer to run. Indeed, this is a legit
# thing to do for a system administrator who wants to be in complete control of
# the system. However, the goal of the image we're building is not to change the
# OS's standard behavior, just modify him enough to make Vagrant work.
# 
# So with the following settings, we delay the APT daily timer enough to let
# initial provisioning complete or at least start, but we don't push it so far
# back that system updates effectively becomes disabled in case the developer is
# using the machine for only short periods of time.
# 
# See: https://github.com/martinanderssondotcom/box-ubuntu-budgie-17-x64/issues/3
# 
# Explanation:
# 
#   "OnCalendar="
#     removes previous settings
#   "OnBootSec=1h 30min" and "RandomizedDelaySec=30min"
#     delays the timer with 1.5 > 2 hours
#   "AccuracySec=1h"
#     may delay the timer further with 1 hour if OS wants to
#   "OnUnitActiveSec=1d"
#     re-run the timer each day the machine is active/running
#   "Persistent=false"
#     don't try to catch up on missed events
#     (should not be needed since we removed the "OnCalendar" property)
# 
# Properties are declared here in the order they are described in the official
# docs: https://www.freedesktop.org/software/systemd/man/systemd.timer.html
DIR=/etc/systemd/system/apt-daily.timer.d
mkdir $DIR

echo '[Timer]
OnCalendar=
OnBootSec=1h 30min
OnUnitActiveSec=1d
AccuracySec=1h
RandomizedDelaySec=30min
Persistent=false' > $DIR/delayed-start-after-boot.conf



# Authorize Vagrant's insecure public SSH key
mkdir /home/vagrant/.ssh/
chmod 700 /home/vagrant/.ssh/
wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh/

# Set root password to "vagrant"
echo root:vagrant | chpasswd

# Passwordless sudo
echo '\nvagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers



# Update/upgrade
apt-get update
apt-get full-upgrade -y



# Delete stuff
apt-get --purge autoremove -y
apt-get clean

rm -rf /var/log/*
rm -rf /home/vagrant/.cache/*
rm -rf /root/.cache/*
rm -rf /var/cache/*
rm -rf /var/tmp/*
rm -rf /tmp/*

# Clear recent bash history
cat /dev/null > /home/vagrant/.bash_history
cat /dev/null > /root/.bash_history

# Fill empty space with zeroes
set +e
# This is supposed to crash with an error message:
#   "dd: error writing 'zerofile': No space left on device"
dd if=/dev/zero of=zerofile bs=1M
set -e

rm -f zerofile
sync