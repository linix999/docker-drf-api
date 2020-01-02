cd /Work/ApiService/
uwsgi -d --ini uwsgi.ini
sleep 2s
/etc/init.d/nginx restart
