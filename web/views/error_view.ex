defmodule Steps.ErrorView do
  use Steps.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  def render("error.json", %{message: message}) do
    render("errors.json", %{messages: [message]})
  end

  def render("errors.json", %{messages: messages}) do
    %{
      errors: Enum.map(messages, &%{detail: &1})
    }
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
