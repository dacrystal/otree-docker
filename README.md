
# Otree Docker Image
This docker image is for otree application.
It will automatically install application requirements specified in requirements files. 
Also, it will do a `resetdb` for the first time.

*Note: for non-`docker-compose` user* : The image doesn't contain a database so you have to create a separate database
container (which is no effort if you use the provided configuration for
*docker-compose*) and link this container or pass the database information.

## Usage


First clone(download) this repo:

    git clone https://github.com/dacrystal/otree-docker <unique-project-name> && cd <unique-project-name>

Then clone(or copy) your otree project in inside it. And make sure it renamed to `app` (see [*Configuration: APP_SRC*](#configuration)):

    git clone <your-otree-project-repo> app
    
    
To start otree services, use [Docker-Compose](https://docs.docker.com/compose/) in the root directory
that contains the provided `docker-compose.yml`:

    docker-compose up --build -d

This will launch your otree site on port 80(default). If you want custom
the otree settings, see [*Configuration*](#configuration).


As database data are defined as *volumes* in the `docker-compose.yml`,
you can easily update your otree without `resetdb` with:

    docker-compose up --build -d

If you need to `resetdb`, then: 

    docker-compose down -v && docker-compose up --build -d


###Project name(WARNING)###
  Docker project volumes are bind to docker-compose's project name. 
  Docker-composer use the root directory base-name as default project name. 
  To avoid, data override, please use a unique directory name per project even if they are in different parent directory.

####docker-compose commands####

```shell
# Start all containers
docker-compose up -d

# Start all containers with rebuilding image
docker-compose up --build -d

# Stop containers
docker-compose down

# Stop containers and delete all data
docker-compose down -v
```


## Additional python modules

All additional python module should be add to requirements.txt in you otree project.


## Configuration 

### Database (.env file) options
    - `PG_DATABASE`: database name
    - `PG_USER`: database user 
    - `PG_PASSWORD`: database password

### Otree (.env file) options
    - `OTREE_PORT`: web port
    - `OTREE_ADMIN_PASSWORD`: otree admin password
    - `OTREE_PRODUCTION`: otree production mode
    - `OTREE_AUTH_LEVEL`

### Other (.env file) options
    - `APP_SRC` relative path to otree project (default: 'app')


## Links

- Otree : [http://otree.readthedocs.io/en/latest/](http://otree.readthedocs.io/en/latest/)
