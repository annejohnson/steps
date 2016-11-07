defmodule Steps.API.V1.SessionView do
  use Steps.Web, :view

  alias Steps.API.V1.UserView

  def render("show.json", attrs) do
    %{
      data: render("session.json", attrs)
    }
  end

  def render("session.json", %{user: user, jwt: jwt, exp: exp}) do
    %{
      type: "sessions",
      attributes: %{
        jwt: jwt,
        exp: exp
      },
      relationships: %{
        user: render_one(user, UserView, "user.json")
      }
    }
  end
end
