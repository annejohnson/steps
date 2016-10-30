defmodule Steps.StepControllerTest do
  use Steps.ConnCase

  alias Plug.Conn
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

  @tag login_as: "anne"
  test "updates a step and redirects", %{conn: conn, user: user} do
    goal = insert_goal(user)
    step = insert_step(goal, @valid_attrs)
    conn = put conn,
               goal_step_path(conn, :update, goal, step),
               step: Dict.merge(@valid_attrs, %{notes: "Worked so hard today"})

    updated_step = Repo.get_by!(Step, id: step.id)

    assert updated_step.notes == "Worked so hard today"
    assert redirected_to(conn) == goal_path(conn, :show, goal)
  end

  @tag login_as: "anne"
  test "does not update a step and renders errors when invalid",
       %{conn: conn, user: user} do
    goal = insert_goal(user)
    step = insert_step(goal, @valid_attrs)
    conn = put conn,
               goal_step_path(conn, :update, goal, step),
               step: @invalid_attrs

    step_after_put = Repo.get_by!(Step, id: step.id)

    refute step_after_put.notes == @invalid_attrs[:notes]
    assert html_response(conn, 200) =~ "help-block"
  end

  @tag login_as: "anne"
  test "deletes a step and redirects", %{conn: conn, user: user} do
    goal = insert_goal(user, @valid_attrs)
    step = insert_step(goal, @valid_attrs)

    conn = delete conn, goal_step_path(conn, :delete, goal, step)

    assert redirected_to(conn) == goal_path(conn, :show, goal)
    refute Repo.get_by(Step, id: step.id)
  end

  @tag login_as: "anne"
  test "authorizes actions against access by other users",
       %{conn: conn, user: owner} do

    goal = insert_goal(owner)
    step = insert_step(goal)
    non_owner = insert_user(username: "sneaky")
    conn = Conn.assign(conn, :current_user, non_owner)

    assert_error_sent :not_found, fn ->
      get(conn, goal_step_path(conn, :new, goal))
    end
    assert_error_sent :not_found, fn ->
      post(conn, goal_step_path(conn, :create, goal), step: @valid_attrs)
    end
    assert_error_sent :not_found, fn ->
      get(conn, goal_step_path(conn, :edit, goal, step))
    end
    assert_error_sent :not_found, fn ->
      put(conn, goal_step_path(conn, :update, goal, step), step: @valid_attrs)
    end
    assert_error_sent :not_found, fn ->
      delete(conn, goal_step_path(conn, :delete, goal, step))
    end
  end

  defp step_count(query), do: Repo.one(from s in query, select: count(s.id))
end
