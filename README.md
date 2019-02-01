# ET Admin

Admin Application for Employment Tribunals JADU Replacement

## Introduction

Both ET1 and ET3 applications will send data to this app where the data gets transformed
and distributed to regional offices using ATOS.

The data is also stored in a database in the [et_api](https://github.com/ministryofjustice/et_api) project and this
administration app, whilst being a separate code base for scalability reasons, will share the same postgres database
and redis database.


## Using The Admin

Once you have chosen your preferred route for running the admin :-

Goto http://localhost:3000/admin assuming you are running on port 300 of course

The default admin details are that provided by activeadmin which are

username: admin@example.com
password: password

Or there are 2 more users to demonstrate the users and roles system

username: senioruser@example.com
password: password

username: junioruser@example.com
password: password

These details are setup in the seed data

### Sidekiq WEB UI

The sidekiq WEB UI is integrated into the admin - click on the 'Jobs' tab and as long as you have permissions (admin@example does) then
you will see it inside an iframe that should auto size as the content does.


## Developing And Testing

As this application shares the database with the API, you will first need to run the API in a separate process and take note of the database
host, port etc.. along with the redis host, port etc...  If you can't be bothered with all this hassle, there is an 'umbrella project' at
https://github.com/ministryofjustice/et-full-system which pulls everything together - you can always run that and if you want to just use the admin
use it from there - or if you want to host your own admin, just setup the environment variables to point to the same database.  You can
use 'docker ps' to find out what ports are being forwarded from different services - look for the 'api' service.

See 'Important Environment Variables' below for a list of all the environment variables that you can change (irrespective of if you use docker or not)

### Developing And Testing Using Docker

#### Initial Setup (Run once)

```
    ./bin/dev/docker ./bin/setup
```

#### Running a server

```

./bin/dev/docker-server

```

which will run a server on port 3000

or if port 3000 is in use or you just want to use a different port

```

PORT=3200 ./bin/dev/docker-server

```

which will run a server on port 3200

#### Running commands on the docker box

If you want to connect to the same machine to run other commands whilst the server is running :-


```

./bin/dev/docker-exec bash

```

which will give you a bash session

or you can run other commands - for example

```

./bin/dev/docker-exec bundle exec rails c

```


will give you a rails console


### Developing And Testing Without Docker

This is just a rails app, so if you want to manage the dependencies etc.. yourself and
setup your own database etc.. Just go about things in the normal way, but remembering these pointers

1. The database.yml uses environment variables so it can be checked into the repository.
   But, these also have defaults so if you have a database running on the standard port on localhost and
   has a user of 'postgres' then you will be good to go.  Otherwise set the environment variables below as you 
   see fit
   DB_HOST
   DB_USERNAME
   DB_PASSWORD
   DB_PORT
   DB_NAME


### Important Environment Variables

#### CLOUD_PROVIDER

Defaults to 'amazon' at the moment - valid values are 'amazon' and 'azure'

This switch will eventually be removed, it is only present for the transition from amazon to azure

#### ATOS_API_URL

The admin provides a basic ATOS API client to read the zip files that have been
exported and be able to download them without requiring active_storage.
If this app moves to Rails 5.2 then this may well move to using the active_storage stuff

This environment variable points to the base URL for the API

e.g.
```

ATOS_API_URL=http://localhost:3101/atos_api

```

#### DB_HOST

Sets the hostname where the postgres database is running (defaults to localhost) - must be the same as the running API

#### DB_PORT

Sets the port where the postgres database is listening (defaults to 5432) - must be the same as the running API

#### DB_USERNAME

Sets the db username (defaults to postgres) - must be the same as the running API

#### DB_PASSWORD

Sets the db password (defaults to blank as not required in docker setup) - must be the same as the running API

#### DB_NAME

Sets the db name (defaults to 'et_api_development' which is the default for the API application)

#### ET_API_URL

Provides access to the generic ET API service, which has an endpoint currently used for the reference generator.

#### PORT

The port on which the web server will run - defaults to 3000

#### REDIS_HOST

Sets the redis host where the redis database is running (defaults to localhost)

#### REDIS_PORT

Sets the redis port where the redis database server is listening (defaults to 6379)

#### REDIS_DATABASE

Sets the redis database number (defaults to 1)

#### REDIS_URL

Rather than specifying the above 3, you can use the traditional REDIS_URL environment variable (defaults to the correct URL when using the above 3 environment variables)


