FROM hacdias/webdav:v5 AS webdav

FROM johannesjo/super-productivity:latest

COPY --from=webdav /bin/webdav /usr/local/bin/webdav
COPY super-productivity-addon-entrypoint.sh /usr/local/bin/super-productivity-addon-entrypoint.sh
RUN chmod +x /usr/local/bin/super-productivity-addon-entrypoint.sh

# Expose only the port required for Home Assistant Ingress. WebDAV runs on
# localhost and is proxied through /webdav/ by the upstream nginx template.
EXPOSE 80

ENTRYPOINT ["/usr/local/bin/super-productivity-addon-entrypoint.sh"]
