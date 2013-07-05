=============================
README
=============================

1. Put code to somewhere (<PATH>) on your server
  + <PATH> : the path which you put crawler

2. Setup database
  + Config database: config in '<PATH>/application/configs/application.ini'
  + Create database: run file '<PATH>/sql/structure.sql'

3. Setup web server (virtual host)
  + Apache: See "Setup virtual host on apache"
  + Nginx: See "Setup virtual host on nginx"

4. Setup php constants
  + Login information: USERNAME, PASSWORD
  + Zend path: ZEND_LIBRARY_PATH
      (set mod for this path (a+r))
  + Html file path: SITE_CONTENT_FILE_PATH
      (set mod for this path (a+rw))
  + Log file path: LOG_FILE_DIR
      (set mod for this path (a+rw))
  + Track file path: TRACK_FILE_DIR
      (set mod for this path (a+rw))

5. Setup cron 
  + Cron auto scan or recan all sites
      (1 1 1 * * * php <PATH>/cli/cron/scan-all-sites.php production)

=============================
Setup virtual host on apache
=============================
<VirtualHost *:80>
   DocumentRoot "<PATH>/public"
   ServerName crawler.com

   # This should be omitted in the production environment
   SetEnv APPLICATION_ENV production
   
   Options +FollowSymlinks
   RewriteRule !^/(scripts|styles|images)      /index.php
   
   <Directory "<PATH>/public">
       Options Indexes MultiViews FollowSymLinks
       AllowOverride All
       Order allow,deny
       Allow from all
   </Directory>

</VirtualHost>

=============================
Setup virtual host on nginx
=============================
server {
    server_name  crawler.com;
    autoindex on;
    index index.php;

    root <PATH>/public;

    location / {
        gzip on;
        try_files $uri $uri/ /index.php;
        if (!-e $request_filename){
            rewrite ^.*$ /index.php last;
        }
    }

    location ~ \.php$ {

        include fastcgi_params;
        fastcgi_param APPLICATION_ENV production;
        fastcgi_index  index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_buffers 128 16k;
        fastcgi_buffer_size 16k;
    }
}
