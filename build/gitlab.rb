# Change the external_url to the address your users will type in their browser
# if http
external_url 'http://gitlab.vesource.com/'

# if https
#external_url 'https://gitlab.invalid/'
#nginx['redirect_http_to_https'] = true
#nginx['ssl_certificate'] = "/etc/ssl/certs/ssl-cert-snakeoil.pem"
#nginx['ssl_certificate_key'] = "/etc/ssl/private/ssl-cert-snakeoil.key"

# do you want to enable gitlab-ci? uncomment this
# you also need to configure some runners, which are
# not included in omnibus package and require manual
# setup anyways
# also if ci is at same ip, disable redirect
#ci_external_url 'http://gitlabci.invalid/'
nginx['redirect_http_to_https'] = false

#
# These settings are documented in more detail at
# https://gitlab.com/gitlab-org/gitlab-ce/blob/master/config/gitlab.yml.example#L118
#
gitlab_rails['ldap_enabled'] = false
gitlab_rails['ldap_host'] = 'ldap.invalid'
gitlab_rails['ldap_port'] = 636
gitlab_rails['ldap_uid'] = 'uid'
gitlab_rails['ldap_method'] = 'ssl'
gitlab_rails['ldap_bind_dn'] = 'bind_user'
gitlab_rails['ldap_password'] = 'user_password'
gitlab_rails['ldap_allow_username_or_email_login'] = true
gitlab_rails['ldap_base'] = 'ldap_base'

# might want to disable this if ldap enabled
gitlab_rails['gitlab_signup_enabled'] = true
gitlab_rails['gitlab_signin_enabled'] = true
S
# limit the projects
gitlab_rails['gitlab_default_projects_limit'] = 100

# keep backup for about 4 weeks
gitlab_rails['backup_keep_time'] = 2404800

# unicorn conf
unicorn['worker_processes'] = 4
unicorn['worker_timeout'] = 180

# runit logs
logging['svlogd_size'] = 100 * 1024 * 1024 # rotate after 200 MB of log data
logging['svlogd_num'] = 30 # keep 30 rotated log files
logging['svlogd_timeout'] = 24 * 60 * 60 # rotate after 24 hours
logging['svlogd_filter'] = "gzip" # compress logs with gzip
logging['svlogd_udp'] = nil # transmit log messages via UDP
logging['svlogd_prefix'] = nil # custom prefix for log messages
