defmodule Steps.PageControllerTest do
  use Steps.ConnCase

  test "GET / when not logged in shows a link to log in", %{conn: conn} do
    conn = get conn, "/"
    login_url = session_path(conn, :new)
    assert html_response(conn, 200) =~ ~s(href="#{login_url}")
  end
end
