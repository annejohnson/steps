defmodule Steps.GoalView do
  use Steps.Web, :view

  def title(:new, _), do: "Set New Goal"
  def title(:show, conn), do: goal_name(conn)
  def title(:edit, _), do: "Edit Goal"
  def title(_, _), do: "Goals"

  def goal_name(conn) do
    "#{conn.assigns[:goal].name}"
  end

  def step_short_summary(step) do
    [step.date, step.notes]
    |> Enum.map(&to_string/1)
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.join(": ")
  end
end
