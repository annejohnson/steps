defmodule Steps.API.V1.UserView do
  use Steps.Web, :view

  @attributes ~w(id username name)a

  def render("user.json", user) do
    user
    |> Map.take(@attributes)
  end
end
