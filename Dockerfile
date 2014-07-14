# Use latest Centos w/ Java image from Tony
FROM t0nyhays/jdk7:v2

RUN yum install -y tar

# Clean the metadata
RUN yum clean all

# Add the Wildfly distribution to /opt
RUN cd /opt && curl http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz | tar zx

# Make sure the distribution is available from a well-known place
RUN ln -s /opt/wildfly-8.1.0.Final /opt/wildfly

# Create the wildfly user and group
RUN groupadd -r service -g 11235 && useradd -u 54322 -r -g service -d /opt/wildfly -s /sbin/nologin -c "WildFly user" wildfly

RUN chown -R wildfly:service /opt/wildfly/*

RUN /opt/wildfly/bin/add-user.sh deploy D3ploy --silent

EXPOSE 8080 9990

USER wildfly

CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
