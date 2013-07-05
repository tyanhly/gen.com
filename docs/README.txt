README
======

This directory should be used to place project specfic documentation including
but not limited to project notes, generated API/phpdoc documentation, or
manual files generated or hand written.  Ideally, this directory would remain
in your development environment only and should not be deployed with your
application to it's final production location.


Setting Up Your VHOST
=====================

The following is a sample VHOST you might want to consider for your project.

<VirtualHost *:80>
   DocumentRoot "/server/staff/tung.ly/Zend/workspaces/DefaultWorkspace7/gen/public"
   ServerName gen.local

   # This should be omitted in the production environment
   SetEnv APPLICATION_ENV development

   <Directory "/server/staff/tung.ly/Zend/workspaces/DefaultWorkspace7/gen/public">
       Options Indexes MultiViews FollowSymLinks
       AllowOverride All
       Order allow,deny
       Allow from all
   </Directory>

</VirtualHost>
