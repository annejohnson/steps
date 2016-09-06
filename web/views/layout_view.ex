defmodule Steps.LayoutView do
  use Steps.Web, :view

  def title(conn, base_title) do
    try do
      [
        apply(view_module(conn), :title, [action_name(conn), conn]),
        base_title
      ] |> Enum.join(" | ")
    rescue _ ->
      base_title
    end
  end
end
