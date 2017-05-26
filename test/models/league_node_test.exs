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

  test "changeset builds ancestry from its parent" do
    root = insert(:league_node)
    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    child = %LeagueNode{}
    |> LeagueNode.changeset(%{name: "child", parent: parent})
    |> Repo.insert!

    assert child.ancestors == [parent.id, root.id]
    assert child.root_id == root.id
  end

  test "changeset builds ancestry from its parent with string params" do
    root = insert(:league_node)
    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    child = %LeagueNode{}
    |> LeagueNode.changeset(%{"name" => "child", "parent" => parent})
    |> Repo.insert!

    assert child.ancestors == [parent.id, root.id]
    assert child.root_id == root.id
  end

  test "changeset sets the root_id properly for the first child" do
    root = insert(:league_node)
    child = %LeagueNode{}
    |> LeagueNode.changeset(%{name: "child", parent: root})
    |> Repo.insert!

    assert child.ancestors == [root.id]
    assert child.root_id == root.id
  end

  test "changeset accepts ancestors and root_id as well" do
    root = insert(:league_node)
    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    child = %LeagueNode{}
    |> LeagueNode.changeset(%{name: "child", ancestors: [parent.id, root.id], root_id: root.id})
    |> Repo.insert!

    assert child.ancestors == [parent.id, root.id]
    assert child.root_id == root.id
  end

  test "changeset is invalid if the root_id does not exist" do
    {:error, changeset} = %LeagueNode{}
    |> LeagueNode.changeset(%{name: "child", root_id: 42})
    |> Repo.insert

    refute changeset.valid?
  end

  test "changeset gives specified ancestors and root_id precedence over parent values" do
    root = insert(:league_node)
    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    child = %LeagueNode{}
    |> LeagueNode.changeset(%{name: "child", ancestors: [root.id], root_id: parent.id, parent: parent})
    |> Repo.insert!

    assert child.ancestors == [root.id]
    assert child.root_id == parent.id
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
