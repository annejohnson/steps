defmodule Steps.SharedView do
  use Steps.Web, :view

  def back_link(url) do
    link "<< Back", to: url, class: "back"
  end
end
