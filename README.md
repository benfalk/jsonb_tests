# jsonb Postgres 9.4 Tests

This is a simple test bed for playing around with the features of jsonb, both
inside of sql and with ActiveRecord. It creates two tables that are identical
and with the one difference being one is jsonb and the other json.  The `users`
table is jsonb while the `customers` table is plain json.

## Getting This Going

Note: This requires Ruby with bundler, preferably Ruby 2.2.0.  If you have `rvm`
or `rbenv` there is a `.ruby-version` in the project to set this for you.  It
also utilizes [docker](https://docs.docker.com/) for the postgres 9.4.  You
don't need this; however, if you aren't using it you'll need to make sure the
`config/database.yml` is set correctly for your configuration.

1. git clone https://github.com/benfalk/jsonb_tests.git
2. `bundle install`
3. `rake docker_create` ( postgres on 127.0.0.1:30101 with your username, no password )
4. give docker about ten seconds or so to finish starting then `rake db:create`
5. `rake db:migrate`
6. `rake add_users` ( creates a million records, takes ~15min on macbook pro )
6. `rake add_customers` ( creates a million records, takes ~15min on macbook pro )

## Table Structure

It's identical for both `users` and `customers`:

```
                                                         Table "public.users"
   Column   |            Type             |                     Modifiers                      | Storage  | Stats target | Description
------------+-----------------------------+----------------------------------------------------+----------+--------------+-------------
 id         | integer                     | not null default nextval('users_id_seq'::regclass) | plain    |              |
 details    | jsonb                       | not null default '{}'::jsonb                       | extended |              |
 created_at | timestamp without time zone | not null                                           | plain    |              |
 updated_at | timestamp without time zone | not null                                           | plain    |              |
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
```

The `details` json structure is as follows:

```
{
  address: {
    city: String,
    street_address: String,
    zip: String,
    state: String,
  contact_me: Boolean,
  first_name: String,
  last_name: String,
  age: Integer,
  bio: String
}
```

## Playing Around

### REPL

`rake console` starts a repl where you can play with ActiveRecord and the two
models `User` and `Customer`.

### psql directly

```
  psql -h 127.0.0.1 -p 30101 jsonb_tests
```
