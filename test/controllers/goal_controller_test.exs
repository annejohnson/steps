defmodule Steps.GoalControllerTest do
  use Steps.ConnCase

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
    user_goal = insert_goal(user, name: "Complete Phoenix app", description: "")
    other_goal = insert_goal(insert_user(username: "max"), name: "Study for exam", description: "")

    conn = get conn, goal_path(conn, :index)
    assert html_response(conn, 200)
    assert String.contains?(conn.resp_body, user_goal.name)
    refute String.contains?(conn. resp_body, other_goal.name)
  end
end
