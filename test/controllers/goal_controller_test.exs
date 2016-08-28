defmodule Steps.GoalControllerTest do
  use Steps.ConnCase

  alias Steps.Goal
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, goal_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing goals"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, goal_path(conn, :new)
    assert html_response(conn, 200) =~ "New goal"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, goal_path(conn, :create), goal: @valid_attrs
    assert redirected_to(conn) == goal_path(conn, :index)
    assert Repo.get_by(Goal, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, goal_path(conn, :create), goal: @invalid_attrs
    assert html_response(conn, 200) =~ "New goal"
  end

  test "shows chosen resource", %{conn: conn} do
    goal = Repo.insert! %Goal{}
    conn = get conn, goal_path(conn, :show, goal)
    assert html_response(conn, 200) =~ "Show goal"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, goal_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    goal = Repo.insert! %Goal{}
    conn = get conn, goal_path(conn, :edit, goal)
    assert html_response(conn, 200) =~ "Edit goal"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    goal = Repo.insert! %Goal{}
    conn = put conn, goal_path(conn, :update, goal), goal: @valid_attrs
    assert redirected_to(conn) == goal_path(conn, :show, goal)
    assert Repo.get_by(Goal, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    goal = Repo.insert! %Goal{}
    conn = put conn, goal_path(conn, :update, goal), goal: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit goal"
  end

  test "deletes chosen resource", %{conn: conn} do
    goal = Repo.insert! %Goal{}
    conn = delete conn, goal_path(conn, :delete, goal)
    assert redirected_to(conn) == goal_path(conn, :index)
    refute Repo.get(Goal, goal.id)
  end
end
