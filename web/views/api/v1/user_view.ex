defmodule Steps.API.V1.UserView do
  use Steps.Web, :view

  @attributes ~w(id username name)a

  def render("user.json", %{user: user}) do
    %{
      type: "users",
      id: user.id,
      attributes: Map.take(user, @attributes)
    }
  end
end
