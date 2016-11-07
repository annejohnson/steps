defmodule Steps.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Phoenix.ConnTest
  alias Ecto.Adapters.SQL.Sandbox
  alias Plug.Conn
  alias Steps.{TestHelpers, Repo, Router}
  alias Steps.Auth.Browser, as: BrowserAuth

  require Phoenix.ConnTest

  # The default endpoint for testing
  @endpoint Steps.Endpoint

  using do
    quote do
      # Import conveniences for testing with connections
      use ConnTest

      alias Steps.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Steps.Router.Helpers
      import Steps.TestHelpers

      # The default endpoint for testing
      @endpoint Steps.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    conn = ConnTest.build_conn

    cond do
      username = tags[:login_as] ->
        user = TestHelpers.insert_user(username: username)

        conn =
          conn
          |> ConnTest.bypass_through(Router, [:browser])
          |> ConnTest.get("/")
          |> BrowserAuth.sign_in(user)
          |> Conn.send_resp(200, "Flush the session")
          |> ConnTest.recycle

        {:ok, conn: conn, user: user}

      username = tags[:api_auth_as] ->
        user = TestHelpers.insert_user(username: username)
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)

        conn =
          conn
          |> Conn.put_req_header("authorization", "Bearer #{jwt}")

        {:ok, conn: conn, user: user}

      true ->
        {:ok, conn: conn}
    end
  end
end
