# Steps

To start this Phoenix app:

  * Install Docker and Docker Compose
  * `docker-compose up -d`
  * `docker-compose run web mix deps.get`
  * `docker-compose run web mix ecto.create`
  * `docker-compose run web mix ecto.migrate`
  * `docker-compose restart web`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
