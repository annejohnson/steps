defmodule Steps.StepView do
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
end
