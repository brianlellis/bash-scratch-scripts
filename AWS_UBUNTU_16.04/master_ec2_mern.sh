$ sudo apt-get update && sudo apt-get upgrade -y
$ sudo apt-get install nginx -y
$ sudo systemctl enable nginx
$ sudo apt-get update
$ sudo apt-get install build-essential libssl-dev
$ curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.5/install.sh -o install_nvm.sh
$ bash install_nvm.sh
$ source ~/.profile
$ nvm install 10.0
$ nvm use 10.0
$ sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/backup.default
$ sudo apt-get install mongodb -y
$ sudo apt-get update -y
$ sudo service mongodb start
$ sudo service mongodb status
$ cd ~/.ssh
$ ssh-keygen
$ cat id_rsa.pub
$ sudo rm index.nginx-debian.html
$ sudo chmod 777 /var/www/html/
$ git clone [my repository] .
$ sudo chmod 755 /var/www/html/
$ curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
$ echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt-get update && sudo apt-get install yarn
$ n=$(which node); \
$ n=${n%/bin/node}; \
$ chmod -R 755 $n/bin/*; \
$ sudo cp -r $n/{bin,lib,share} /usr/local