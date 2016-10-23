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

  def dates_with_steps(goal, num_days_ago: num_days_ago) do
    steps = goal.steps
    Enum.map(dates(num_days_ago: num_days_ago), fn(date) ->
      {date, step_for_date(steps, date)}
    end)
  end

  defp dates(num_days_ago: num_days_ago) do
    num_days_ago..0
    |> Enum.map(&Chronos.days_ago/1)
  end

  defp step_for_date(steps, date) do
    Enum.find(steps, fn(step) ->
      step.date == Ecto.Date.cast!(date)
    end)
  end
end
