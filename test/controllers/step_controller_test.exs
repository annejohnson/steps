defmodule Steps.StepControllerTest do
  use Steps.ConnCase

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
end
