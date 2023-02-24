# Installation

### 1. Install ruby version manager (one of these list)

* [rvm](https://rvm.io)
* [rbenv](https://github.com/rbenv/rbenv)
* [asdf](https://asdf-vm.com)

### 2. Install [Postgres](https://www.postgresql.org)

### 3. Export Postgres environment URL in file `.env.local`

```
POSTGRES_HOST="127.0.0.1"
POSTGRES_DATABASE="store_app_development"
POSTGRES_USERNAME="postgres"
POSTGRES_PASSWORD="postgres"
```


### 4. Create Postgres Database

```
bin/rails db:create
```


### 3. Migrate Postgres Database

```
bin/rails db:migrate
```

### 5. Install BackEnd Dependencies

```
bundle install
```

___

# Run

```
bundle exec rails s
```
