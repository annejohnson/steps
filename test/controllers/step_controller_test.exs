defmodule Steps.StepControllerTest do
  use Steps.ConnCase

  alias Steps.Step

  @valid_attrs %{date: {2016, 6, 11}, notes: "Success!"}
  @invalid_attrs %{date: nil, notes: "Bad data"}

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, goal_step_path(conn, :new, "123")),
      get(conn, goal_step_path(conn, :edit, "123", "456")),
      put(conn, goal_step_path(conn, :update, "123", "456", %{})),
      post(conn, goal_step_path(conn, :create, "123", %{})),
      delete(conn, goal_step_path(conn, :delete, "123", "456"))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "anne"
  test "creates a step and redirects", %{conn: conn, user: user} do
    goal = insert_goal(user)
    conn = post conn, goal_step_path(conn, :create, goal), step: @valid_attrs
    new_step = Repo.get_by!(Step, @valid_attrs)

    assert new_step.goal_id == goal.id
    assert redirected_to(conn) == goal_path(conn, :show, goal)
  end

  @tag login_as: "anne"
  test "does not create a step and renders errors when invalid",
       %{conn: conn, user: user} do
    count_before = step_count(Step)
    goal = insert_goal(user)

    conn = post conn, goal_step_path(conn, :create, goal), step: @invalid_attrs
    assert html_response(conn, 200) =~ "help-block"
    assert step_count(Step) == count_before
  end

  defp step_count(query), do: Repo.one(from s in query, select: count(s.id))
end
