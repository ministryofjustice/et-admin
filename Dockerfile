FROM ministryofjustice/ruby:2.5.1-webapp-onbuild

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y pdftk

EXPOSE 8080

RUN bash -c "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production ATOS_API_USERNAME=foo ATOS_API_PASSWORD=bar SECRET_KEY_BASE=foo"

RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
RUN mkdir /etc/cron.d
RUN touch /etc/cron.d/awslogs
RUN apt-get update
RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/supervisor/conf.d/
COPY supervisor_awslogs.conf /etc/supervisor/conf.d/
COPY supervisor.conf /etc/supervisor.conf

CMD ["./run.sh"]
