defmodule Steps.AuthTest do
  use Steps.ConnCase

  alias Steps.Auth

  test "check authorization with a valid username and pass", _ do
    insert_user(username: "anne", password: "mostsecret")

    {:ok, authenticated_user} =
      Auth.check_username_and_pass("anne", "mostsecret", repo: Repo)

    assert authenticated_user.username == "anne"
  end

  test "check authorization with a not found user", _ do
    assert {:error, :not_found} =
      Auth.check_username_and_pass("joe", "secrets", repo: Repo)
  end

  test "check authorization with a password mismatch", _ do
    _ = insert_user(username: "anne", password: "mostsecret")
    assert {:error, :unauthorized} =
      Auth.check_username_and_pass("anne", "wrongsecret", repo: Repo)
  end
end
