defmodule Steps.API.V1.StepController do
  use Steps.Web, :controller
  alias Steps.{Step, Repo}

  def index(conn, _) do
    json(conn, %{data: "hi"})
  end

  def show(conn, %{"id" => id}) do
    step = Repo.get!(Step, id)
    render conn, "show.json", %{data: step}
  end

  def create(conn, _) do
  end

  def update(conn, _) do
  end

  def delete(conn, _) do
  end
end
