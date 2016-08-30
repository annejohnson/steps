defmodule Steps.StepController do
  use Steps.Web, :controller

  alias Steps.Step

  plug :assign_goal

  def action(conn, _) do
    apply(__MODULE__,
          action_name(conn),
          [conn, conn.params, conn.assigns.goal])
  end

  def index(conn, _params, goal) do
    steps = Repo.all(goal_steps(goal))
    render(conn, "index.html", steps: steps)
  end

  def new(conn, _params, goal) do
    changeset =
      goal
      |> build_assoc(:steps)
      |> Step.changeset(new_step_defaults)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"step" => step_params}, goal) do
    changeset =
      goal
      |> build_assoc(:steps)
      |> Step.changeset(step_params)

    case Repo.insert(changeset) do
      {:ok, _step} ->
        conn
        |> put_flash(:info, "Step created successfully.")
        |> redirect(to: goal_step_path(conn, :index, goal))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, goal) do
    step = Repo.get!(goal_steps(goal), id)
    render(conn, "show.html", step: step)
  end

  def edit(conn, %{"id" => id}, goal) do
    step = Repo.get!(goal_steps(goal), id)
    changeset = Step.changeset(step)
    render(conn, "edit.html", step: step, changeset: changeset)
  end

  def update(conn, %{"id" => id, "step" => step_params}, goal) do
    step = Repo.get!(goal_steps(goal), id)
    changeset = Step.changeset(step, step_params)

    case Repo.update(changeset) do
      {:ok, step} ->
        conn
        |> put_flash(:info, "Step updated successfully.")
        |> redirect(to: goal_step_path(conn, :show, goal, step))
      {:error, changeset} ->
        render(conn, "edit.html", step: step, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, goal) do
    step = Repo.get!(goal_steps(goal), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(step)

    conn
    |> put_flash(:info, "Step deleted successfully.")
    |> redirect(to: goal_step_path(conn, :index, goal))
  end

  defp assign_goal(conn, _opts) do
    case conn.params do
      %{"goal_id" => goal_id} ->
        goal =
          conn.assigns.current_user
          |> user_goals
          |> Repo.get(goal_id)
        assign(conn, :goal, goal)
      _ ->
        conn
    end
  end

  defp user_goals(user) do
    assoc(user, :goals)
  end

  defp goal_steps(goal) do
    from s in assoc(goal, :steps), order_by: [desc: s.date]
  end

  defp new_step_defaults do
    %{"date" => :calendar.universal_time}
  end
end
