defmodule Steps.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller

  alias Steps.User
  alias Guardian.Plug, as: GuardianPlug

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
end
