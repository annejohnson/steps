defmodule Steps.API.V1.SessionControllerTest do
  use Steps.ConnCase

  test "returns a JWT and user info for valid login credentials",
       %{conn: conn} do
    password = "unicorn"
    %{id: user_id, username: username} =
      insert_user(username: "anne", password: password)

    new_conn =
      post(
        conn,
        api_v1_session_path(
          conn,
          :create,
          %{username: username, password: password}
        )
      )

    assert(
      %{
        "data" => %{
          "type" => "sessions",
          "attributes" => %{
            "jwt" => _jwt,
            "exp" => _exp
          },
          "relationships" => %{
            "user" => %{
              "type" => "users",
              "id" => ^user_id,
              "attributes" => %{"username" => ^username}
            }
          }
        }
      } = json_response(new_conn, 200)
    )
  end

  test "returns an error message when passed invalid login credentials",
       %{conn: conn} do

    insert_user(username: "anne", password: "unicorn")

    new_conn =
      post(
        conn,
        api_v1_session_path(
          conn,
          :create,
          %{username: "anne", password: "wrongpassword"}
        )
      )

    response = json_response(new_conn, 401)

    refute(Dict.has_key?(response, "data"))

    assert(%{
      "errors" => [
        %{
          "detail" => "Unable to authenticate user"
        }
      ]
    } = response)
  end
end
