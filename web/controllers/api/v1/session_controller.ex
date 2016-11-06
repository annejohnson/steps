defmodule Steps.API.V1.SessionController do
  use Steps.Web, :controller

  alias Steps.Auth
  alias Guardian.Plug, as: GuardianPlug

  def create(conn,
             %{"username" => username, "password" => pass}) do
    case Auth.check_username_and_pass(username, pass, repo: Repo) do
      {:ok, user} ->
        new_conn = GuardianPlug.api_sign_in(conn, user)
        jwt = GuardianPlug.current_token(new_conn)
        {:ok, claims} = GuardianPlug.claims(new_conn)
        exp = Map.get(claims, "exp")

        new_conn
        |> put_resp_header("authorization", "Bearer #{jwt}")
        |> put_resp_header("x-expires", to_string(exp))
        |> render("session.json", %{user: user, jwt: jwt, exp: exp})
      {:error, _reason} ->
        conn
        |> put_status(401)
        |> put_view(Steps.ErrorView)
        |> render("error.json", %{message: "Unable to authenticate"})
    end
  end
end
