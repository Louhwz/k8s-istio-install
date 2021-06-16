set -e

NewPort=22222
FilePath=/etc/ssh/sshd_config


sed -i "s/#Port 22/Port $NewPort/g" $FilePath
systemctl restart sshd
semanage port -a -t ssh_port_t -p tcp $NewPort