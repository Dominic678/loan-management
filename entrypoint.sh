#!/bin/bash
set -e

cd /home/frappe/frappe-bench

SITE_NAME="${SITE_NAME:-loan.local}"
DB_HOST="${DB_HOST:-loan-mariadb}"
REDIS_HOST="${REDIS_URL:-redis://loan-redis:6379}"

# Point the bench at the external DB/Redis services (Render private services)
bench set-config -g db_host "$DB_HOST"
bench set-config -gp db_port 3306
bench set-config -g redis_cache "$REDIS_HOST/0"
bench set-config -g redis_queue "$REDIS_HOST/1"
bench set-config -g redis_socketio "$REDIS_HOST/1"

# Create the site only the very first time the disk is empty
if [ ! -d "sites/$SITE_NAME" ]; then
	echo "No site found. Creating $SITE_NAME ..."
	bench new-site "$SITE_NAME" \
		--mariadb-root-password "$DB_ROOT_PASSWORD" \
		--admin-password "$ADMIN_PASSWORD" \
		--install-app erpnext \
		--install-app custom_loan_theme \
		--set-default \
		--no-mariadb-socket
else
	echo "Site $SITE_NAME already exists, skipping creation."
fi

# bench start runs web server + websocket + scheduler + worker together
# (see Procfile) -- perfect for a single-service Render deployment.
exec bench start
