defmodule Steps.API.V1.GoalControllerTest do
  use Steps.ConnCase

  @valid_attrs %{name: "Write a novel",
                 description: "Complete by the end of October."}
  @invalid_attrs %{name: ""}

  test "requires a valid JWT for all actions", %{conn: conn} do
    Enum.each([
      get(conn, api_v1_goal_path(conn, :index)),
      get(conn, api_v1_goal_path(conn, :show, "123")),
      put(conn, api_v1_goal_path(conn, :update, "123", %{})),
      post(conn, api_v1_goal_path(conn, :create, %{})),
      delete(conn, api_v1_goal_path(conn, :delete, "123"))
    ], fn conn ->
      assert(
        %{
          "errors" => [%{"detail" => _message}]
        } = json_response(conn, 401)
      )
    end)
  end

  test "doesn't allow :update, :delete, or :show of another user's goal",
       %{conn: conn} do
    owner = insert_user(username: "anne")
    goal = insert_goal(owner)

    non_owner = insert_user(username: "sneaky", password: "sneakytastic")

    # TODO: write test
  end

  @tag api_auth_as: "anne"
  test "shows a user's goals", %{conn: conn, user: user} do
    goal1 =
      insert_goal(user, name: "Run 3 miles", description: "oiejoiqj")
    goal2 =
      insert_goal(user, name: "Walk 10,000 steps each day", description: "kije")

    other_user = insert_user(name: "joe")
    insert_goal(other_user, name: "Lift twice a week", description: "abiwe!")

    new_conn = get(conn, api_v1_goal_path(conn, :index))

    response = json_response(new_conn, 200)
    assert(length(response["data"]) == 2)

    assert(
      Enum.find(response["data"], fn %{"id" => id,
                                       "type" => "goals",
                                       "attributes" => attrs} ->
        id == goal1.id &&
        attrs["name"] == goal1.name &&
        attrs["description"] == goal1.description
      end)
    )

    assert(
      Enum.find(response["data"], fn %{"id" => id,
                                       "type" => "goals",
                                       "attributes" => attrs} ->
        id == goal2.id &&
        attrs["name"] == goal2.name &&
        attrs["description"] == goal2.description
      end)
    )
  end

  @tag api_auth_as: "anne"
  test "shows the specified goal", %{conn: conn, user: user} do
    %{
      id: goal_id,
      name: goal_name,
      description: goal_description
    } = insert_goal(user, name: "Speak Latin", description: "Lorem ipsum")

    new_conn = get(conn, api_v1_goal_path(conn, :show, goal_id))

    assert(
      %{
        "data" => %{
          "type" => "goals",
          "id" => ^goal_id,
          "attributes" => %{
            "name" => ^goal_name,
            "description" => ^goal_description
          }
        }
      } = json_response(new_conn, 200)
    )
  end

  test "creates a goal when given valid params", %{conn: _conn} do
  end

  test "doesn't create a goal when given invalid params", %{conn: _conn} do
  end

  test "updates a goal when given valid params", %{conn: _conn} do
  end

  test "doesn't update a goal when given invalid params", %{conn: _conn} do
  end

  test "deletes the specified goal", %{conn: _conn} do
  end
end
