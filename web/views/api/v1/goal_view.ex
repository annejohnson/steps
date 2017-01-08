defmodule Steps.API.V1.GoalView do
  use Steps.Web, :view

  @attributes ~w(name description created_at)a

  def render("index.json", %{goals: goals}) do
    %{
      data: render_many(goals, __MODULE__, "goal.json")
    }
  end

  def render("show.json", %{goal: goal}) do
    %{
      data: render_one(goal, __MODULE__, "goal.json")
    }
  end

  def render("goal.json", %{goal: goal}) do
    %{
      type: "goals",
      id: goal.id,
      attributes: Map.take(goal, @attributes)
    }
  end
end
