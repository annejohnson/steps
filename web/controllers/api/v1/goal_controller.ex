defmodule Steps.API.V1.GoalController do
  use Steps.Web, :controller
  alias Steps.{Auth, Goal, Repo}

  def index(conn, _) do
    goals =
      conn
      |> Auth.current_user
      |> Goal.for_user
      |> Repo.all

    render conn, "index.json", %{goals: goals}
  end

  def show(conn, %{"id" => id}) do
    goal =
      conn
      |> Auth.current_user
      |> Goal.for_user
      |> Repo.get!(id)

    render conn, "show.json", %{goal: goal}
  end

  def create(conn, _) do
  end

  def update(conn, _) do
  end

  def delete(conn, _) do
  end
end
