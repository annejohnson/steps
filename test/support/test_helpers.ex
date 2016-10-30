defmodule Steps.TestHelpers do
  alias Ecto.Date
  alias Steps.{Repo, User}

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
      password: "supersecret"
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!
  end

  def insert_goal(user, attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Run a mile",
      description: "Run every day in order to work up to running a mile."
    }, attrs)

    user
    |> Ecto.build_assoc(:goals, changes)
    |> Repo.insert!
  end

  def insert_step(goal, attrs \\ %{}) do
    changes = Dict.merge(%{
      notes: "Ran 10 minutes outside.",
      date: {2016, 1, 10}
    }, attrs)
    changes = %{changes | date: Date.cast!(changes.date)}

    goal
    |> Ecto.build_assoc(:steps, changes)
    |> Repo.insert!
  end
end
