# Homework

You will need to have postgres running.
The easiest way to install postgres is through brew:
`brew install postgres`

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
     * If you get an error that says The database for Homework.Repo couldn't be created: killed, then run: '/usr/local/opt/postgres/bin/createuser -s postgres'
  
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:8000`](http://localhost:8000) from your browser.
You can use [`localhost:8000/graphiql`](http://localhost:8000/graphiql) to make basic graphql queries from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
