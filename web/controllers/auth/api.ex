defmodule Steps.Auth.API do
  use Steps.Web, :controller

  def unauthenticated(conn, _opts) do
    conn
    |> put_status(401)
    |> put_view(Steps.ErrorView)
    |> render("error.json", %{message: "Authentication required"})
  end
end
