defmodule Steps.PageController do
  use Steps.Web, :controller
  alias Steps.Auth

  def index(conn, _params) do
    case Auth.current_user(conn) do
      nil ->
        render conn, "index.html"
      _ ->
        conn
        |> redirect(to: goal_path(conn, :index))
    end
  end
end
