defmodule Steps.GoalControllerTest do
  use Steps.ConnCase
  alias Plug.Conn
  alias Steps.Goal

  @valid_attrs %{name: "Write a novel",
                 description: "Complete by the end of October."}
  @invalid_attrs %{name: ""}

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, goal_path(conn, :new)),
      get(conn, goal_path(conn, :index)),
      get(conn, goal_path(conn, :show, "123")),
      get(conn, goal_path(conn, :edit, "123")),
      put(conn, goal_path(conn, :update, "123", %{})),
      post(conn, goal_path(conn, :create, %{})),
      delete(conn, goal_path(conn, :delete, "123"))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag login_as: "anne"
  test "lists all user's goals on index", %{conn: conn, user: user} do
    user_goal_a = insert_goal(user, name: "Complete Phoenix app")
    user_goal_b = insert_goal(user, name: "Do a split")
    other_goal = insert_goal(
      insert_user(username: "max"),
      name: "Study for exam"
    )

    conn = get conn, goal_path(conn, :index)
    assert html_response(conn, 200)

    Enum.each([user_goal_a, user_goal_b], fn user_goal ->
      assert String.contains?(conn.resp_body, user_goal.name)
    end)
    refute String.contains?(conn. resp_body, other_goal.name)
  end

  @tag login_as: "anne"
  test "lists the goal's description and steps on show",
       %{conn: conn, user: user} do
    goal = insert_goal(
      user,
      name: "Complete Phoenix app",
      description: "Work hard"
    )
    steps = [
      insert_step(goal, date: {2015, 11, 2}, notes: "Step 1"),
      insert_step(goal, date: {2016, 4, 10}, notes: "Step 2")
    ]

    other_goal = insert_goal(user, name: "Run more frequently")
    other_goal_steps = [
      insert_step(other_goal, date: {2015, 11, 2}, notes: "Step A"),
      insert_step(other_goal, date: {2016, 4, 10}, notes: "Step B")
    ]

    conn = get conn, goal_path(conn, :show, goal)
    assert html_response(conn, 200) =~ goal.description

    Enum.each(steps, fn step ->
      assert String.contains?(conn.resp_body, step.notes)
    end)
    Enum.each(other_goal_steps, fn step ->
      refute String.contains?(conn.resp_body, step.notes)
    end)
  end

  @tag login_as: "anne"
  test "creates a goal and redirects", %{conn: conn, user: user} do
    conn = post conn, goal_path(conn, :create), goal: @valid_attrs
    new_goal = Repo.get_by!(Goal, @valid_attrs)

    assert new_goal.user_id == user.id
    assert redirected_to(conn) == goal_path(conn, :show, new_goal)
  end

  @tag login_as: "anne"
  test "does not create a goal and renders errors when invalid",
       %{conn: conn} do
    count_before = goal_count(Goal)
    conn = post conn, goal_path(conn, :create), goal: @invalid_attrs
    assert html_response(conn, 200) =~ "help-block"
    assert goal_count(Goal) == count_before
  end

  @tag login_as: "anne"
  test "updates a goal and redirects", %{conn: conn, user: user} do
    goal = insert_goal(user, @valid_attrs)

    conn = put conn,
               goal_path(conn, :update, goal),
               goal: Dict.merge(@valid_attrs, %{name: "Run very far"})

    updated_goal = Repo.get_by!(Goal, id: goal.id)

    assert updated_goal.name == "Run very far"
    assert redirected_to(conn) == goal_path(conn, :show, updated_goal)
  end

  @tag login_as: "anne"
  test "does not update a goal and renders errors when invalid",
       %{conn: conn, user: user} do
    goal = insert_goal(user, @valid_attrs)

    conn = put conn,
               goal_path(conn, :update, goal),
               goal: @invalid_attrs
    assert html_response(conn, 200) =~ "help-block"
  end

  @tag login_as: "anne"
  test "deletes a goal and redirects", %{conn: conn, user: user} do
    goal = insert_goal(user, @valid_attrs)

    conn = delete conn, goal_path(conn, :delete, goal)

    assert redirected_to(conn) == goal_path(conn, :index)
    refute Repo.get_by(Goal, id: goal.id)
  end

  @tag login_as: "anne"
  test "authorizes actions against access by other users",
       %{conn: conn, user: owner} do

    goal = insert_goal(owner, @valid_attrs)
    non_owner = insert_user(username: "sneaky")
    conn = Conn.assign(conn, :current_user, non_owner)

    assert_error_sent :not_found, fn ->
      get(conn, goal_path(conn, :show, goal))
    end
    assert_error_sent :not_found, fn ->
      get(conn, goal_path(conn, :edit, goal))
    end
    assert_error_sent :not_found, fn ->
      put(conn, goal_path(conn, :update, goal, goal: @valid_attrs))
    end
    assert_error_sent :not_found, fn ->
      delete(conn, goal_path(conn, :delete, goal))
    end
  end

  defp goal_count(query), do: Repo.one(from g in query, select: count(g.id))
end
