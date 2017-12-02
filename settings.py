# Defaults are found in
# https://github.com/voxpupuli/puppetboard/blob/v0.3.0/puppetboard/default_settings.py

# PuppetDB connection variables
PUPPETDB_HOST = 'puppetdb'
PUPPETDB_PORT = 8081

# SSL keys and certs
PUPPETDB_SSL_VERIFY = '/opt/puppetboard/keys/ca.pem'
PUPPETDB_KEY = '/opt/puppetboard/keys/key.pem'
PUPPETDB_CERT = '/opt/puppetboard/keys/cert.pem'

# Misc
DEFAULT_ENVIRONMENT = '*'
ENABLE_CATALOG = True
LITTLE_TABLE_COUNT = 25
