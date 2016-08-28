defmodule Steps.UserController do
  use Steps.Web, :controller

  def index(conn, _params) do
    users = Repo.all(Steps.User)
    render conn, "index.html", users: users
  end
end
