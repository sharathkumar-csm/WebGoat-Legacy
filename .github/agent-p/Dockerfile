# Agent P 1.0.0. WebGoat-Legacy requires Java 8, absent from the stock runtime.
# Built only on the workflow runner; no registry publication is required.
FROM sonatype/agp@sha256:12a772057cc62118a4de6e1b6e8c68df739ff209afb91b67d96c4b5eadfd9337
USER root
RUN apk add --no-cache openjdk8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"
COPY --chmod=0755 entrypoint.sh /usr/local/bin/agp-webgoat-entrypoint
ENTRYPOINT ["/usr/local/bin/agp-webgoat-entrypoint"]
