defmodule Steps.StepTest do
  use Steps.ModelCase

  alias Steps.Step

  @valid_attrs %{date: %{day: 17, month: 4, year: 2010}, notes: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Step.changeset(%Step{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Step.changeset(%Step{}, @invalid_attrs)
    refute changeset.valid?
  end
end
