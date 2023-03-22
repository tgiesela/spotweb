import os
DATA_DIR = os.path.realpath(os.path.expanduser(u'/config/'))
SQLITE_PATH = os.path.join(DATA_DIR, 'pgadmin4.db')
SESSION_DB_PATH = os.path.join(DATA_DIR, 'sessions')
STORAGE_DIR = os.path.join(DATA_DIR, 'storage')
SERVER_MODE = True
LOG_FILE = os.path.join(DATA_DIR,'log/pgadmin.log')
LOG_ROTATION_SIZE = 10  # In MBs
LOG_ROTATION_AGE = 1440  # In minutes
LOG_ROTATION_MAX_LOG_FILES = 5  # Maximum number of backups to retain
DEFAULT_SERVER = '0.0.0.0'
DEFAULT_SERVER_PORT = int(os.getenv('PGADMIN_LISTEN_PORT', 5050))

MAIL_SERVER = '<mailserver>'
MAIL_PORT = <mailserverport>
MAIL_USE_SSL = <mailusessl>
MAIL_USE_TLS = <mailusetls>
MAIL_USERNAME = '<mailuser>'
MAIL_PASSWORD = '<mailpassword>'

