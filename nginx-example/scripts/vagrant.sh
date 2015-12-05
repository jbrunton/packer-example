# Taken from: https://github.com/shiguredo/packer-templates/blob/develop/ubuntu-12.04/scripts/base.sh
rm /var/lib/apt/lists/*
apt-get update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r)

sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers

# Taken from: https://github.com/shiguredo/packer-templates/blob/develop/ubuntu-12.04/scripts/vagrant.sh
echo "UseDNS no" >> /etc/ssh/sshd_config

date > /etc/vagrant_box_build_time

mkdir -p /home/vagrant/.ssh
wget --no-check-certificate \
    'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' \
    -O /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh

# https://github.com/shiguredo/packer-templates/blob/develop/ubuntu-12.04/scripts/virtualbox.sh
apt-get -y install dkms
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

# Install ngingx
apt-get install -y nginx
sudo /etc/init.d/nginx start
