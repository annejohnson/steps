defmodule Steps.API.V1.StepControllerTest do
  use Steps.ConnCase

  test "requires a valid JWT for all actions", %{conn: conn} do
    Enum.each([
      get(conn, api_v1_step_path(conn, :index)),
      get(conn, api_v1_step_path(conn, :show, "123")),
      put(conn, api_v1_step_path(conn, :update, "123", %{})),
      post(conn, api_v1_step_path(conn, :create, %{})),
      delete(conn, api_v1_step_path(conn, :delete, "123"))
    ], fn conn ->
      assert(
        %{
          "errors" => [%{"detail" => _message}]
        } = json_response(conn, 401)
      )
    end)
  end
end
