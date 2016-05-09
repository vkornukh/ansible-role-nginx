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

A docroot '/var/www/testsite' will be created holding `up.json` with the specified content.  The config in `site.j2` will be used for the site.
There is a stub config in `roles/nginx/templates/` that can be used, but it's unlikely to support the exact configuration you need, which is why using an external template is supported.  

For Ubuntu systems, it is possible to install the PPA rather than the standard package-managed version. This can be done by specifying 
`nginx_ppa_install: true` in the playbook. To specify a version of nginx to install from the PPA, use the `nginx_ppa_version_string` variable.
However, note that the [PPA](http://www.ubuntuupdates.org/ppa/nginx) doesn't appear to keep historical versions, so pin to a specific version
at your own risk. If a new package is released, playbooks using a pinned version are likely to start failing.

## Example Invocations
<pre>
- role: nginx
  nginx_sites:
    - name: "{{ app_name }}.conf"
      template: templates/nginx.conf.j2
</pre>

<pre>
- role: nginx
  nginx_sites:
    - name: testsite
      template: site.j2
      files:
        - name: up.json
          content: '{ "status": "happy" }' 
</pre>

<pre>
- role: nginx
  nginx_sites:
    - name: "{{ app_name }}.conf"
      template: templates/nginx.conf.j2
</pre>

<pre>
- role: nginx
  nginx_ppa_install: true
  nginx_sites:
    - name: "{{ app_name }}.conf"
      template: templates/nginx.conf.j2
</pre>

<pre>
- role: nginx
  nginx_ppa_install: true
  nginx_ppa_version_string: nginx=1.10.0-0+trusty0
  nginx_sites:
    - name: "{{ app_name }}.conf"
      template: templates/nginx.conf.j2
</pre>
