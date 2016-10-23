defmodule Steps.GoalController do
  use Steps.Web, :controller

  alias Steps.{Goal, Step}

  def action(conn, _) do
    apply(__MODULE__,
          action_name(conn),
          [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    render(
      conn,
      "index.html",
      goals_with_dates_and_steps: goals_with_dates_and_steps(user, days_ago: 20)
    )
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
           |> Goal.for_user
           |> Repo.get!(id)
    steps = Repo.all(from s in assoc(goal, :steps), order_by: [desc: s.date])
    dates_with_steps = dates_with_steps(dates(days_ago: 20), steps)

    render(
      conn,
      "show.html",
      goal: goal,
      steps: steps,
      dates_with_steps: dates_with_steps
    )
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

  defp dates(days_ago: days_ago) do
    days_ago..0
    |> Enum.map(&Chronos.days_ago/1)
  end

  defp goals_with_dates_and_steps(user, days_ago: days_ago) do
    goals = user
            |> Goal.for_user(with_steps_since_date: Chronos.days_ago(days_ago))
            |> Repo.all
    dates = dates(days_ago: days_ago)

    Enum.map(goals, fn(goal) ->
      {goal, dates_with_steps(dates, goal.steps)}
    end)
  end

  defp dates_with_steps(dates, steps) do
    Enum.map(dates, fn(date) ->
      {date, step_for_date(steps, date)}
    end)
  end

  defp step_for_date(steps, date) do
    Enum.find(steps, fn(step) ->
      step.date == Ecto.Date.cast!(date)
    end)
  end
end
