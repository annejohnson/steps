defmodule Steps.API.V1.SessionView do
  use Steps.Web, :view

  alias Steps.API.V1.UserView

  def render("session.json", %{user: user, jwt: jwt, exp: exp}) do
    %{
      jwt: jwt,
      exp: exp,
      user: UserView.render("user.json", user)
    }
  end
end
