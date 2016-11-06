defmodule Steps.Auth.Browser do
  import Plug.Conn
  import Phoenix.Controller

  alias Steps.Router.Helpers
  alias Guardian.Plug, as: GuardianPlug

  def sign_in(conn, user) do
    GuardianPlug.sign_in(conn, user, :token)
  end

  def sign_out(conn) do
    GuardianPlug.sign_out(conn)
  end

  def unauthenticated(conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to access that page")
    |> redirect(to: Helpers.page_path(conn, :index))
    |> halt
  end
end
