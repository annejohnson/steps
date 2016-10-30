defmodule Steps.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller

  alias Steps.Router.Helpers
  alias Steps.User
  alias Guardian.Plug, as: GuardianPlug

  def sign_in(conn, user) do
    GuardianPlug.sign_in(conn, user, :token)
  end

  def sign_out(conn) do
    GuardianPlug.sign_out(conn)
  end

  def current_user(conn) do
    GuardianPlug.current_resource(conn)
  end

  def check_username_and_pass(username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, username: username)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        dummy_checkpw
        {:error, :not_found}
    end
  end

  def unauthenticated(conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to access that page")
    |> redirect(to: Helpers.page_path(conn, :index))
    |> halt
  end
end
