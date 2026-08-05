#!/bin/bash
set -e

cat <<EOF > /usr/share/nginx/html/assets/env.js
window.__env = {
  ENDPOINT: "${ENDPOINT}" || (window.location.protocol + "//" + window.location.hostname + ":9080"),
  ACCESS_KEY: "${ACCESS_KEY:-zippy}",
  SECRET_KEY: "${SECRET_KEY:-zippy}",
  REGION: "${REGION:-default}",
  PRODUCT_NAME: "${PRODUCT_NAME:-Storage Ceph Object Developer Edition}",
  PRODUCT_VERSION: "${PRODUCT_VERSION:-9.9.2.0}",
};
EOF

echo "Preparing Ceph directories and permissions..."
mkdir -p /var/lib/ceph/rgw_posix_driver \
         /var/lib/ceph/rgw_posix_db \
         /home/ceph/.aws \
         /var/run/ceph \
         /var/log/ceph \
         /run/nginx

chown -R 167:167 /var/lib/ceph /home/ceph /var/run/ceph /var/log/ceph

ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

function start_nginx_proxy_server() {
    echo "Starting Object browser..."
    nginx -g 'daemon off;' &
}

function start_ceph_rgw_backend() {
    echo "Starting RGW standalone server..."
    /usr/local/bin/entrypoint.sh &
}

start_ceph_rgw_backend
start_nginx_proxy_server

wait -n # keeping the container alive
