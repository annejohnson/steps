defmodule Steps.Repo.Migrations.CreateStep do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :notes, :text
      add :date, :date
      add :goal_id, references(:goals, on_delete: :delete_all)

      timestamps
    end

    create index(:steps, [:goal_id])
    create index(:steps, [:date])
    create unique_index(:steps, [:date, :goal_id])
  end
end
