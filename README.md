# Steps

To start this Phoenix app:

  * Install Docker and Docker Compose
  * `docker-compose up -d`
  * `docker-compose run web mix deps.get`
  * `docker-compose run web mix ecto.create`
  * `docker-compose run web mix ecto.migrate`
  * `docker-compose restart web`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
