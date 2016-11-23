FROM consul:0.7.1

COPY load.sh /usr/local/bin/load
COPY snapshot.sh /usr/local/bin/snapshot

VOLUME /consul/snapshots

ENV CONSUL_ENTRYPOINT=/usr/local/bin/docker-entrypoint.sh
ENV SNAPSHOT=/consul/snapshots/state.snap

ENTRYPOINT ["/usr/local/bin/load"]
CMD ["agent", "-dev", "-client", "0.0.0.0"]
