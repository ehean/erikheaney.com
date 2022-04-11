#!/bin/sh

# Install ufw (firewall), zabbix (resource monitoring), nginx (reverse-proxy), tor (privacy tool)
apt upgrade
apt update
apt install ufw 
apt install zabbix
apt install zabbix-agent
apt install nginx
apt install tor
apt install git

# Install Go for Hugo
mkdir build
cd ~/build
wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz
echo "path+=('/home/user/go/bin')" >> ~/.bashrc
echo "path+=('/usr/local/go/bin')" >> ~/.bashrc
source ~/.bashrc 
go version

# Install hugo (open source, static site creator)
apt install hugo
hugo version

# Setup nginx reverse proxy

echo "server {


	root /var/erikheaney.com/erikheaney/public;

	index index.html index.htm index.nginx-debian.html;

	server_name www.erikheaney.com;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}

    # SSL support. Key generated from LetsEncrypt. Managed by certbot.
    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/erikheaney.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/erikheaney.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


        # Proxy requests from the plausible script contained in the site header to plausible agent
        location /js/plausible.js {
              proxy_pass http://localhost:8000/js/plausible.js;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        # Redirected requests from the /analytics pages to be proxied to plausible agent
        location /plausible {
              proxy_pass http://localhost:8000/;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        # Proxy /api requests to plausible agent
        location /api {
            proxy_pass http://erikheaney.com:8000/api;
            proxy_buffering on;
            proxy_http_version 1.1;

            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host  $host;

            proxy_set_header Host erikheaney.com;
            proxy_ssl_name erikheaney.com;
            proxy_ssl_server_name on;
            proxy_ssl_session_reuse off;
        }

        location /analytics/ {
              # Update headers to redirect to the /analytics path
              proxy_redirect ~*(.*) /analytics/$1; 
              proxy_pass http://localhost:8000/;
  
              # Replace the links in the response to prepend the /analytics path
              sub_filter 'href=\"/' 'href=\"/analytics/';

              # Replace the src to point to plausible
              sub_filter 'src=\"/' 'src=\"/plausible/';
              sub_filter_once off;
        }

}

server {
    if ($host = www.erikheaney.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = erikheaney.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


	listen 80 default_server;
	listen [::]:80 default_server;

	server_name www.erikheaney.com;
    return 404; # managed by Certbot
}" >> /etc/nginx/sites-enabled/erikheaney
sudo ln -s /etc/nginx/sites-available/erikheaney /etc/nginx/sites-enabled/erikheaney


# Install certbot, EFF's SSL cert manager. It uses the Let's Encrypt CA.
apt install certbot
apt install python3-certbot-nginx

# Run certbot
certbot --nginx -d erikheaney.com -d www.erikheaney.com

# Confirm SSL key was created
ls -lrt /etc/letsencrypt/live/erikheaney.com/privkey.pem

# Renew certificate hourly via cron
crontab -l > renew_cert
echo "0 12 * * * /usr/bin/certbot renew --quiet" >> renew_cert
crontab renew_cert
rm renew_cert

# Start nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Setup hugo repo
mkdir -p /var/www/
cd /var/www
git clone --recurse-submodules git@github.com:ehean/erikheaney.com.git

# Test Hugo
hugo server -D

# Run hugo
hugo -D

# Install docker for plausible
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get install docker-ce docker-ce-cli containerd.io
docker run hello-world

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Setup plausible
cd /var/www/
git clone https://github.com/plausible/hosting
cd hosting
echo "ADMIN_USER_EMAIL=\"eheaney98@gmail.com\"
ADMIN_USER_NAME=\"Erik Heaney\"
ADMIN_USER_PWD=replace-me
BASE_URL=\"https://erikheaney.com\"
SECRET_KEY_BASE=\"GSgVrUksU6H2/LnoyL3zPk2RAyTXdEDSnEmt0dzW+Pg5Rv+oqkmne2ehzd0jVgYjWwzhHgi9lVlegOWZIq9byg==\"" >> plausible-conf.env 
docker-compose up -d

# Setup ufw 
echo "{
\"iptables\": false
}" > /etc/docker/daemon.json
systemctl restart docker
sed -i -e 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw
iptables -t nat -A POSTROUTING ! -o docker0 -s 172.17.0.0/16 -j MASQUERADE
ufw allow ssh
ufw allow http
ufw allow https
ufw enable
