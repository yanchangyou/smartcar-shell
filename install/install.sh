
echo config dns
sudo bash -c "echo nameserver 114.114.114.114 > /etc/resolv.config"

echo config apt source aliyun
sudo bash -c "echo deb http://mirrors.aliyun.com/raspbian/raspbian/ wheezy main non-free contrib > /etc/apt/sources.list"
sudo bash -c "echo deb-src http://mirrors.aliyun.com/raspbian/raspbian/ wheezy main non-free contrib >> /etc/apt/sources.list"

echo apt update
sudo apt-get update

echo all install to /opt directory

echo instal gpio wiringPi
cd /opt
sudo rm -rf wiringPi
sudo git clone git://git.drogon.net/wiringPi

cd wiringPi
sudo ./build

echo test gpio
gpio -v

echo install lirc
sudo apt-get install lirc -y

echo config gpio use pin 25
sudo modprobe lirc_rpi gpio_in_pin=25 gpio_out_pin=2

echo test
echo sudo mode2 -d /dev/lirc0

echo config
sudo sed -i "4cLIRCD_ARGS=\"--uinput\"" /etc/lirc/hardware.conf
sudo sed -i "16cDRIVER=\"default\"" /etc/lirc/hardware.conf
sudo sed -i "18cDEVICE=\"/dev/lirc0\"" /etc/lirc/hardware.conf

echo record buttons
sudo /etc/init.d/lirc stop
sudo rm ~/lircd.conf
sudo irrecord -n -d /dev/lirc0 ~/lircd.conf
sudo mv ~/lircd.conf /etc/lirc/lircd.conf
sudo /etc/init.d/lirc start

#echo test
#echo irw

echo install car
cd /opt
sudo rm -rf smartcar-shell
sudo git clone git://github.com/yanchangyou/smartcar-shell
cd smartcar-shell/bin
sudo chmod +x *.sh

echo start smart car
./start.sh
