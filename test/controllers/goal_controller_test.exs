defmodule Steps.GoalControllerTest do
  use Steps.ConnCase
  alias Steps.Goal

  @valid_attrs %{name: "Write a novel", description: "Complete by the end of October."}
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
    other_goal = insert_goal(insert_user(username: "max"), name: "Study for exam")

    conn = get conn, goal_path(conn, :index)
    assert html_response(conn, 200)

    Enum.each([user_goal_a, user_goal_b], fn user_goal ->
      assert String.contains?(conn.resp_body, user_goal.name)
    end)
    refute String.contains?(conn. resp_body, other_goal.name)
  end

  @tag login_as: "anne"
  test "creates a goal and redirects", %{conn: conn, user: user} do
    conn = post conn, goal_path(conn, :create), goal: @valid_attrs
    new_goal = Repo.get_by!(Goal, @valid_attrs)

    assert new_goal.user_id == user.id
    assert redirected_to(conn) == goal_path(conn, :show, new_goal)
  end

  @tag login_as: "anne"
  test "does not create a goal and renders errors when invalid", %{conn: conn} do
    count_before = goal_count(Goal)
    conn = post conn, goal_path(conn, :create), goal: @invalid_attrs
    assert html_response(conn, 200) =~ "check the errors"
    assert goal_count(Goal) == count_before
  end

  defp goal_count(query), do: Repo.one(from g in query, select: count(g.id))
end
