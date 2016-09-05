defmodule Steps.Step do
  use Steps.Web, :model

  schema "steps" do
    field :notes, :string
    field :date, Ecto.Date
    belongs_to :goal, Steps.Goal

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:notes, :date])
    |> validate_required([:date])
    |> unique_constraint(:date_goal_id, message: "Step already taken on this date.")
  end

  def for_goal(goal) do
    from s in assoc(goal, :steps),
      order_by: [desc: s.date]
  end
end
