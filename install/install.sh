
echo config dns
echo nameserver 114.114.114.114 > /etc/resolv.config

echo config apt source aliyun
echo deb http://mirrors.aliyun.com/raspbian/raspbian/ wheezy main non-free contrib > /etc/apt/sources.list
echo deb-src http://mirrors.aliyun.com/raspbian/raspbian/ wheezy main non-free contrib >> /etc/apt/sources.list

echo apt update
apt-get update

echo all install to /opt directory

echo instal gpio wiringPi
cd /opt
rm -rf wiringPi
git clone git://git.drogon.net/wiringPi
cd wiringPi
./build
gpio -v

echo install lirc
apt-get install lirc -y

echo config gpio use pin 25
modprobe lirc_rpi gpio_in_pin=25 gpio_out_pin=2

#echo test
#echo mode2 -d /dev/lirc0

echo config
sed -i "4cLIRCD_ARGS=\"--uinput\"" /etc/lirc/hardware.conf
sed -i "16cDRIVER=\"default\"" /etc/lirc/hardware.conf
sed -i "18cDEVICE=\"/dev/lirc0\"" /etc/lirc/hardware.conf

echo record buttons
/etc/init.d/lirc stop
rm ~/lircd.conf
irrecord -n -d /dev/lirc0 ~/lircd.conf
mv ~/lircd.conf /etc/lirc/lircd.conf
/etc/init.d/lirc start

#echo test
#echo irw

echo install car
cd /opt
rm -rf smartcar-shell
git clone git://github.com/yanchangyou/smartcar-shell

echo start smart car
cd smartcar-shell/bin
chmod +x *.sh

echo start car on boot
sed -i '$d' /etc/rc.local
echo start car on boot >> /etc/rc.local
echo modprobe lirc_rpi gpio_in_pin=25 gpio_out_pin=2 >> /etc/rc.local
echo /etc/init.d/lirc start >> /etc/rc.local
echo cd /opt/smartcar-shell/bin >> /etc/rc.local
echo ./start.sh \& >> /etc/rc.local
echo exit 0 >> /etc/rc.local

./start.sh
