#!/bin/bash


######### BACKEND SETUP OF TAIGA #################
#GET TAIGA ESSENTIAL PACKAGES
sudo apt-get update
sudo apt-get install -y build-essential binutils-doc autoconf flex bison libjpeg-dev
sudo apt-get install -y libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev
sudo apt-get install -y automake libtool libffi-dev curl git tmux gettext
sudo apt-get install -y nginx
sudo apt-get install -y rabbitmq-server redis-server

#INSTALL POSTGRES
sudo apt-get install -y postgresql-9.5 postgresql-contrib-9.5
sudo apt-get install -y postgresql-doc-9.5 postgresql-server-dev-9.5

#PYTHON3 && VIRTUALENVWRAPPER
sudo apt-get install -y python3 python3-pip python-dev python3-dev python-pip virtualenvwrapper
sudo apt-get install -y libxml2-dev libxslt-dev
sudo apt-get install -y libssl-dev libffi-dev

#MANDATORY USER CREATION
sudo adduser taiga
sudo adduser taiga sudo
sudo su taiga
cd ~

#POSTGRES
sudo -u postgres createuser taiga
sudo -u postgres createdb taiga -O taiga --encoding='utf-8' --locale=en_US.utf8 --template=template0

# rabbitmq
sudo rabbitmqctl add_user taiga PASSWORD_FOR_EVENTS
sudo rabbitmqctl add_vhost taiga
sudo rabbitmqctl set_permissions -p taiga taiga ".*" ".*" ".*"

#DOWNLOAD TAIGA BACKEND
cd ~
git clone https://github.com/taigaio/taiga-back.git taiga-back
cd taiga-back
git checkout stable

#SETUP VIRTUAL ENV
mkvirtualenv -p /usr/bin/python3 taiga

#INSTALL APP DEPS
pip install -r requirements.txt

#POPULATE DB WITH BASE INFO
python manage.py migrate --noinput
python manage.py loaddata initial_user
python manage.py loaddata initial_project_templates
python manage.py compilemessages
python manage.py collectstatic --noinput

## SETUP CONFIG

sudo cat > ~/taiga-back/settings/local.py <<EOF
from .common import *

MEDIA_URL = "/media/"
STATIC_URL = "/static/"
ADMIN_MEDIA_PREFIX = "/static/admin/"
SITES["front"]["scheme"] = "http"
SITES["front"]["domain"] = "CHANGEME"
SITES["api"]["scheme"] = "http"
SITES["api"]["domain"] = "CHANGEME"

SECRET_KEY = "theveryultratopsecretkey"

DEBUG = False
PUBLIC_REGISTER_ENABLED = True

DEFAULT_FROM_EMAIL = "no-reply@example.com"
SERVER_EMAIL = DEFAULT_FROM_EMAIL

#CELERY_ENABLED = True

EVENTS_PUSH_BACKEND = "taiga.events.backends.rabbitmq.EventsPushBackend"
EVENTS_PUSH_BACKEND_OPTIONS = {"url": "amqp://taiga:PASSWORD_FOR_EVENTS@localhost:5672/taiga"}

# Uncomment and populate with proper connection parameters
# for enable email sending. EMAIL_HOST_USER should end by @domain.tld
#EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
#EMAIL_USE_TLS = False
#EMAIL_HOST = "localhost"
#EMAIL_HOST_USER = ""
#EMAIL_HOST_PASSWORD = ""
#EMAIL_PORT = 25

# Uncomment and populate with proper connection parameters
# for enable github login/singin.
#GITHUB_API_CLIENT_ID = "yourgithubclientid"
#GITHUB_API_CLIENT_SECRET = "yourgithubclientsecret"

# SLACK
INSTALLED_APPS += ["taiga_contrib_slack"]
EOF

######### FRONTEND SETUP OF TAIGA #################
#DOWNLOAD TAIGA FRONTEND
cd ~
git clone https://github.com/taigaio/taiga-front-dist.git taiga-front-dist
cd taiga-front-dist
git checkout stable

#CREATE CONFIG FILE
sudo cat > ~/taiga-front-dist/dist/conf.json <<EOF
{
    "api": "/api/v1/",
    "eventsUrl": null,
    "eventsMaxMissedHeartbeats": 5,
    "eventsHeartbeatIntervalTime": 60000,
    "eventsReconnectTryInterval": 10000,
    "debug": true,
    "debugInfo": false,
    "defaultLanguage": "en",
    "themes": ["taiga"],
    "defaultTheme": "taiga",
    "publicRegisterEnabled": true,
    "feedbackEnabled": true,
    "supportUrl": "https://tree.taiga.io/support",
    "privacyPolicyUrl": null,
    "termsOfServiceUrl": null,
    "GDPRUrl": null,
    "maxUploadFileSize": null,
    "contribPlugins": ["/plugins/slack/slack.json"],
    "tribeHost": null,
    "importers": [],
    "gravatar": true,
    "rtlLanguages": ["fa"]
}
EOF

######### WEBSOCKET/RABBITMQ SETUP OF TAIGA #################
#DOWNLOAD TAIGA EVENTS
cd ~
git clone https://github.com/taigaio/taiga-events.git taiga-events
cd taiga-events

# NODEJS + NVM
cd ~
curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs
sudo rm nodesource_setup.sh

#YARN SETUP
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarnl
sudo apt-get install --no-install-recommends yarn
yarn -v

#INIT PACKAGE.JSON
yarn

#EDIT THE CONFIG FILE
sudo cat > ~/taiga-events/config.json <<EOF
{
    "url": "amqp://guest:guest@localhost:5672",
    "secret": "mysecret",
    "webSocketServer": {
        "port": 8888
    }
}
EOF

sudo cat > /etc/systemd/system/taiga_events.service <<EOF
[Unit]
Description=taiga_events
After=network.target

[Service]
User=taiga
WorkingDirectory=/home/taiga/taiga-events
ExecStart=/bin/bash -c "node_modules/coffeescript/bin/coffee index.coffee"
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF

#RELOAD SYSTEMD CONFIGS
sudo systemctl daemon-reload
sudo systemctl start taiga_events
sudo systemctl enable taiga_events

######### SYSTEMD && GUNICORN #################
sudo cat > /etc/systemd/system/taiga.service <<EOF
[Unit]
Description=taiga_back
After=network.target

[Service]
User=taiga
Environment=PYTHONUNBUFFERED=true
WorkingDirectory=/home/taiga/taiga-back
ExecStart=/home/taiga/.virtualenvs/taiga/bin/gunicorn --workers 4 --timeout 60 -b 127.0.0.1:8001 taiga.wsgi
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF

#RELOAD SYSTEMD CONFIGS
sudo systemctl daemon-reload
sudo systemctl start taiga
sudo systemctl enable taiga

######### NGINX SETUP OF TAIGA #################
#REMOVE DEFAULT AND SET UP LOGS DIR
sudo rm /etc/nginx/sites-enabled/default
mkdir -p ~/logs

#NEW CONF FILE
sudo cat > /etc/nginx/conf.d/taiga.conf <<EOF
server {
    listen 80 default_server;
    server_name _;

    large_client_header_buffers 4 32k;
    client_max_body_size 50M;
    charset utf-8;

    access_log /home/taiga/logs/nginx.access.log;
    error_log /home/taiga/logs/nginx.error.log;

    # Frontend
    location / {
        root /home/taiga/taiga-front-dist/dist/;
        try_files $uri $uri/ /index.html;
    }

    # Backend
    location /api {
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:8001/api;
        proxy_redirect off;
    }

    # Django admin access (/admin/)
    location /admin {
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://127.0.0.1:8001$request_uri;
        proxy_redirect off;
    }

    # Static files
    location /static {
        alias /home/taiga/taiga-back/static;
    }

    # Media files
    location /media {
        alias /home/taiga/taiga-back/media;
    }

	# Taiga-events
	location /events {
	proxy_pass http://127.0.0.1:8888/events;
	proxy_http_version 1.1;
	proxy_set_header Upgrade $http_upgrade;
	proxy_set_header Connection "upgrade";
	proxy_connect_timeout 7d;
	proxy_send_timeout 7d;
	proxy_read_timeout 7d;
	}
}
EOF

#RESTART NGINX
sudo systemctl restart nginx

###########################################
######### CONTRIB PLUGINS #################
###########################################

########### SLACK ###############
sudo -u apt-get install -y subversion
pip install taiga-contrib-slack
cd ~/taiga-back

cd ~/taiga-front-dist/dist
mkdir -p plugins
cd plugins
svn export "https://github.com/taigaio/taiga-contrib-slack/tags/$(pip show taiga-contrib-slack | awk '/^Version: /{print $2}')/front/dist" "slack"
sudo systemctl restart taiga
