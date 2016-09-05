defmodule Steps.Goal do
  use Steps.Web, :model

  alias Steps.Step

  schema "goals" do
    field :name, :string
    field :description, :string
    belongs_to :user, Steps.User
    has_many :steps, Steps.Step

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end

  def for_user(user) do
    assoc(user, :goals)
  end

  def for_user(user, with_steps: num_steps) do
    recent_step_query = from s in Step, order_by: [desc: s.date], limit: ^num_steps

    from g in for_user(user),
      preload: [steps: ^recent_step_query]
  end
end
