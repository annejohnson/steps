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
  alias Steps.TestHelpers

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
    :ok = Sandbox.checkout(Steps.Repo)

    unless tags[:async] do
      Sandbox.mode(Steps.Repo, {:shared, self()})
    end

    conn = ConnTest.build_conn()

    if username = tags[:login_as] do
      user = TestHelpers.insert_user(username: username)
      conn = Conn.assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      {:ok, conn: conn}
    end
  end
end
