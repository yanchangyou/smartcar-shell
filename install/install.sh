
#enable root
sudo passwd root
pi
pi

su - root
pi

#config dns
echo nameserver 114.114.114.114 > /etc/resolv.config

#config apt source aliyun
echo deb http://mirrors.aliyun.com/raspbian/raspbian/ wheezy main non-free contrib > /etc/apt/sources.list
echo deb-src http://mirrors.aliyun.com/raspbian/raspbian/ wheezy main non-free contrib >> /etc/apt/sources.list

#apt update
apt-get update

#all install to opt
cd /opt

#instal gpio wiringPi
git clone git://git.drogon.net/wiringPi

cd wiringPi
./build

#test gpio
gpio -v

#install lirc
apt-get install lirc -y

#config gpio
modprobe lirc_rpi gpio_in_pin=25 gpio_out_pin=2

#test
mode2 -d /dev/lirc0

#config
sed -i "4cLIRCD_ARGS=\"--uinput\"" /etc/lirc/hardware.conf
sed -i "16cDRIVER=\"default\"" /etc/lirc/hardware.conf
sed -i "18cDEVICE=\"/dev/lirc0\"" /etc/lirc/hardware.conf

#record buttons
/etc/init.d/lirc stop
irrecord -n -d /dev/lirc0 ~/lircd.conf
mv ~/lircd.conf /etc/lirc/lircd.conf
/etc/init.d/lirc start

#test
irw

#install car
git clone git://github.com/yanchangyou/smartcar
cd smartcar/bin
chmod +x *.sh

#start
./start.sh



