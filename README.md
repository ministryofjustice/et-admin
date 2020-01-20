# ET Admin

[![Build Status](https://dev.azure.com/HMCTS-PET/pet-azure-infrastructure/_apis/build/status/et-admin?branchName=develop)](https://dev.azure.com/HMCTS-PET/pet-azure-infrastructure/_build/latest?definitionId=18&branchName=develop)

Admin Application for Employment Tribunals System

## Introduction

Both ET1 and ET3 applications will send data to this app where the data gets transformed
and distributed to regional offices using ATOS.

The data is also stored in a database in the [et_api](https://github.com/ministryofjustice/et_api) project and this
administration app, whilst being a separate code base for scalability reasons, will share the same postgres database
and redis database.


## Using The Admin

Once you have chosen your preferred route for running the admin :-

Goto http://localhost:3000/admin assuming you are running on port 3000 of course

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
host, port etc.. along with the redis host, port etc...  OR a much easier method is to run within the et_full_system (see below)  - or if you want to host your own admin, just setup the environment variables to point to the same database.  

See 'Important Environment Variables' below for a list of all the environment variables that you can change (irrespective of if you use docker or not)

### Developing And Testing Using The et_full_system gem

Please refer to https://github.com/hmcts/et_full_system_gem for instructions on general use and starting an environment.
Once you have an environment running, read on below ...

#### Developing Locally In Full System

The easiest way to develop is to use the full system to provide everything that you need (database, redis, API etc..)
and use a special command to redirect the full system admin URL to your local machine.
The command to redirect to your local machine on port 3000 is (note you can use any free port) :-

```
et_full_system docker local_admin 3000
```

Then, in this project directory run

```
et_full_system docker admin_env > .env
```

which will setup all environment variables to the correct values to work in the full system environment.

then run

```

rails s

```

which will run the web server.  The url is

http://admin.et.127.0.0.1.nip.io:3100


### Developing And Testing Without Et Full System Gem

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


If your redis server needs a password, it must be specified using

```
REDIS_PASSWORD=<your password>
```


