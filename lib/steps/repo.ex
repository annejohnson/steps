defmodule Steps.Repo do
  # use Ecto.Repo, otp_app: :steps

  def all(Steps.User) do
    [%Steps.User{id: "1", name: "Anne", username: "depaysant", password: "pw1"},
     %Steps.User{id: "2", name: "Glen", username: "baseballkid1994", password: "pw2"},
     %Steps.User{id: "3", name: "Rhett", username: "cincinnatifan", password: "pw3"}]
  end
  def all(_module), do: []

  def get(module, id) do
    Enum.find all(module), fn map -> map.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end
end
