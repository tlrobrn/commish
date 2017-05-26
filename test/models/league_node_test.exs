defmodule Commish.LeagueNodeTest do
  use Commish.ModelCase

  alias Commish.LeagueNode

  @valid_attrs %{name: "some content"}

  test "changeset with valid attributes" do
    changeset = LeagueNode.changeset(%LeagueNode{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with missing name should not be valid" do
    changeset = LeagueNode.changeset(%LeagueNode{}, %{})
    refute changeset.valid?
  end

  test "changeset with invalid ancestry is invalid" do
    {:error, changeset} = %LeagueNode{}
    |> LeagueNode.changeset(%{name: "orphan", ancestors: [123]})
    |> Repo.insert

    refute changeset.valid?
  end

  test "deleting a node deletes all of its descendants" do
    root = insert(:league_node)
    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    _child = build(:league_node) |> with_ancestors([parent.id, root.id]) |> insert

    assert Repo.all(LeagueNode) |> Enum.count == 3
    Repo.delete(root)
    assert Repo.all(LeagueNode) |> Enum.count == 0
  end
end
