defmodule Steps.UserController do
  use Steps.Web, :controller

  def index(conn, _params) do
    users = Repo.all(Steps.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Steps.User, id)
    render conn, "show.html", user: user
  end
end
