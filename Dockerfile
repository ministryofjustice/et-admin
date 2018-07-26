FROM ministryofjustice/ruby:2.5.1-webapp-onbuild

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y pdftk

RUN npm install

EXPOSE 8080

RUN bash -c "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production ATOS_API_USERNAME=foo ATOS_API_PASSWORD=bar"

CMD ["./run.sh"]
