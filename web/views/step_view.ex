defmodule Steps.StepView do
  @num_dates 14

  use Steps.Web, :view

  def title(:new, _), do: "Record New Step"
  def title(:edit, _), do: "Edit Step"

  def step_date_select(form) do
    builder =
      fn b ->
        this_year = Chronos.year
        year_options = 5..0 |> Enum.map(&(this_year - &1))
        day_options = 1..31

        ~e"""
        <%= b.(:month, []) %> / <%= b.(:day, [options: day_options]) %> / <%= b.(:year, [options: year_options]) %>
        """
      end

    date_select form, :date, builder: builder
  end

  def step_short_summary(step) do
    [short_formatted_date(step.date), step.notes]
    |> Enum.map(&to_string/1)
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.join(": ")
  end

  def short_formatted_date(ecto_date) do
    date_tuple = {_, m, _} = Ecto.Date.to_erl(ecto_date)

    # Add dot after month abbreviation (%b) for non-May
    format_str = if m == 5, do: "%b %d, %Y", else: "%b. %d, %Y"

    Chronos.Formatter.strftime(date_tuple, format_str)
  end

  def formatted_date(ecto_date) do
    Chronos.Formatter.strftime(Ecto.Date.to_erl(ecto_date), "%B %d, %Y")
  end

  def dates_with_steps(goal) do
    steps = goal.steps
    Enum.map(dates(num_days_ago: @num_dates - 1), fn(date) ->
      {date, step_for_date(steps, date)}
    end)
  end

  def sort_steps_by_date_desc(steps) do
    Enum.sort(
      steps,
      fn(%{date: date1}, %{date: date2}) ->
        Enum.member?([:eq, :gt], Ecto.Date.compare(date1, date2))
      end
    )
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
