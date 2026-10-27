FROM preprod.icr.io/cp/ibm-ceph/object-browser:1.3.0 AS ui
FROM preprod.icr.io/cpopen/ibm-ceph/rgw-standalone-rhel10:v9.10.0

USER root

RUN grep -lR "/tmp/ceph-pkgset" /etc/yum.repos.d/ | xargs rm -f && \
    microdnf install -y nginx && \
    microdnf clean all

COPY --from=ui /usr/share/nginx/html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 8081 9080

ENTRYPOINT ["/usr/local/bin/init.sh"]
