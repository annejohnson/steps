defmodule Steps.UserView do
  use Steps.Web, :view
  alias Steps.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
