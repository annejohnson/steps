defmodule Steps.API.V1.SessionControllerTest do
  use Steps.ConnCase

  test "returns a JWT and user info for valid login credentials",
       %{conn: conn} do
    insert_user(username: "anne", password: "unicorn")

    new_conn =
      post(
        conn,
        api_v1_session_path(
          conn,
          :create,
          %{username: "anne", password: "unicorn"}
        )
      )

    assert(
      %{
        "user" => %{"username" => "anne"},
        "jwt" => _jwt,
        "exp" => _exp
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

    assert(Dict.has_key?(response, "error_message"))

    refute(Dict.has_key?(response, "jwt"))
    refute(Dict.has_key?(response, "user"))
  end
end
