defmodule Steps.PageController do
  use Steps.Web, :controller

  def index(conn, _params) do
    case conn.assigns.current_user do
      nil ->
        render conn, "index.html"
      _ ->
        conn
        |> redirect(to: goal_path(conn, :index))
    end
  end
end
