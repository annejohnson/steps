defmodule Steps.GoalController do
  use Steps.Web, :controller

  alias Steps.{Goal, Step}

  def action(conn, _) do
    apply(__MODULE__,
          action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    goals =
      user
      |> Goal.for_user(with_steps: true)
      |> Repo.all

    render(conn, "index.html", goals: goals)
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:goals)
      |> Goal.changeset

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"goal" => goal_params}, user) do
    changeset =
      user
      |> build_assoc(:goals)
      |> Goal.changeset(goal_params)

    case Repo.insert(changeset) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal created successfully.")
        |> redirect(to: goal_path(conn, :show, goal))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    goal = user
           |> Goal.for_user(with_steps: true)
           |> Repo.get!(id)

    render(conn, "show.html", goal: goal)
  end

  def edit(conn, %{"id" => id}, user) do
    goal = user
           |> Goal.for_user
           |> Repo.get!(id)
    changeset = Goal.changeset(goal)
    render(conn, "edit.html", goal: goal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "goal" => goal_params}, user) do
    goal = user
           |> Goal.for_user
           |> Repo.get!(id)
    changeset = Goal.changeset(goal, goal_params)

    case Repo.update(changeset) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: goal_path(conn, :show, goal))
      {:error, changeset} ->
        render(conn, "edit.html", goal: goal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    goal = user
           |> Goal.for_user
           |> Repo.get!(id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(goal)

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: goal_path(conn, :index))
  end
end
