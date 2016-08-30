defmodule Steps.Repo.Migrations.CreateGoal do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :name, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps
    end

    create index(:goals, [:user_id])
  end
end
