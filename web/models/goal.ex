defmodule Steps.Goal do
  use Steps.Web, :model

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
end
