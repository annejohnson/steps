defmodule Steps.StepView do
  use Steps.Web, :view

  def title(:new, _), do: "Record New Step"
  def title(:edit, _), do: "Edit Step"
end
