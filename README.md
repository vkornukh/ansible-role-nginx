ansible-role-nginx
====================

A role to install nginx and configure 0 or more sites' doc roots and nginx config files.

An example might be:

<pre>
nginx_sites:
  - name: testsite
    template: site.j2
    files:
    - name: up.json
      content: '{ "status": "happy" }'    
</pre>

With a `site.j2` such as: 

<pre>
server {
  listen 81;
  server_name {{item.name}};
  access_log /var/log/nginx/81.log;
  location /404 {
    return 404;
  }
  location ~ ^/up/?$ {
    root /var/www/{{item.name}};
    rewrite ^.*$ /up.json break;
  }
  location / {
    return 204;
  }
}
</pre>

A docroot '/var/www/testsite' will be created holding `up.json` with the 
specified content.  The config in `site.j2` will be used for the site.  There is a stub config in `roles/nginx/templates/` that can be used, but it's unliekly to support the exact configuration you need, which is why using an external template is supported.  
