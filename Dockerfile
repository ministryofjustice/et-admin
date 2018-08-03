FROM ministryofjustice/ruby:2.5.1-webapp-onbuild

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y pdftk

EXPOSE 8080

RUN bash -c "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production ATOS_API_USERNAME=foo ATOS_API_PASSWORD=bar"

RUN wget https://github.com/papertrail/remote_syslog2/releases/download/v0.20/remote-syslog2_0.20_amd64.deb
RUN dpkg -i remote-syslog2_0.20_amd64.deb
RUN remote_syslog \
  -p 20568 \
  -d logs7.papertrailapp.com \
  --pid-file=/var/run/remote_syslog.pid \
  --hostname=$PAPERTRAIL_NAME-$HOSTNAME \
  /usr/src/app/log/production.log

CMD ["./run.sh"]
