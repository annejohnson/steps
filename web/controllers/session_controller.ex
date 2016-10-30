defmodule Steps.SessionController do
  use Steps.Web, :controller
  alias Steps.Auth
  alias Guardian.Plug, as: GuardianPlug

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case Auth.check_username_and_pass(username, pass, repo: Repo) do
      {:ok, user} ->
        conn
        |> GuardianPlug.sign_in(user, :token)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> GuardianPlug.sign_out
    |> redirect(to: page_path(conn, :index))
  end
end
