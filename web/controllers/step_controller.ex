defmodule Steps.StepController do
  use Steps.Web, :controller

  alias Steps.Step

  def index(conn, _params) do
    steps = Repo.all(Step)
    render(conn, "index.html", steps: steps)
  end

  def new(conn, _params) do
    changeset = Step.changeset(%Step{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"step" => step_params}) do
    changeset = Step.changeset(%Step{}, step_params)

    case Repo.insert(changeset) do
      {:ok, _step} ->
        conn
        |> put_flash(:info, "Step created successfully.")
        |> redirect(to: step_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    step = Repo.get!(Step, id)
    render(conn, "show.html", step: step)
  end

  def edit(conn, %{"id" => id}) do
    step = Repo.get!(Step, id)
    changeset = Step.changeset(step)
    render(conn, "edit.html", step: step, changeset: changeset)
  end

  def update(conn, %{"id" => id, "step" => step_params}) do
    step = Repo.get!(Step, id)
    changeset = Step.changeset(step, step_params)

    case Repo.update(changeset) do
      {:ok, step} ->
        conn
        |> put_flash(:info, "Step updated successfully.")
        |> redirect(to: step_path(conn, :show, step))
      {:error, changeset} ->
        render(conn, "edit.html", step: step, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    step = Repo.get!(Step, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(step)

    conn
    |> put_flash(:info, "Step deleted successfully.")
    |> redirect(to: step_path(conn, :index))
  end
end
