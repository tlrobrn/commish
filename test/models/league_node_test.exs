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

  test "children returns [] for a leaf node" do
    node = insert(:league_node)
    assert LeagueNode.children(node) == []
  end

  test "children returns a node's direct children" do
    parent = insert(:league_node)
    children = [1, 2, 3] |> Enum.map(fn _ ->
      build(:league_node) |> with_ancestors([parent.id]) |> insert
    end)
    _grandchild = build(:league_node) |> with_ancestors([hd(children).id, parent.id]) |> insert

    assert LeagueNode.children(parent) == children
  end

  test "descendants returns [] for a leaf node" do
    node = insert(:league_node)
    assert LeagueNode.descendants(node) == []
  end

  test "descendants returns a node's direct descendants" do
    parent = insert(:league_node)
    children = [1, 2, 3] |> Enum.map(fn _ ->
      build(:league_node) |> with_ancestors([parent.id]) |> insert
    end)
    grandchild = build(:league_node) |> with_ancestors([hd(children).id, parent.id]) |> insert

    assert LeagueNode.descendants(parent) == children ++ [grandchild]
  end

  test "teams_with_ancestry returns [] if a node has no descendants with teams" do
    parent = insert(:league_node)
    _children = [1, 2, 3] |> Enum.map(fn _ ->
      build(:league_node) |> with_ancestors([parent.id]) |> insert
    end)

    assert LeagueNode.teams_with_ancestry(parent) == []
  end

  test "teams_with_ancestry returns its descendants teams" do
    root = insert(:league_node)
    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    team_ids_with_ancestors = [1, 2, 3]
    |> Stream.map(fn _ ->
      node = build(:league_node) |> with_ancestors([parent.id, root.id]) |> insert
      {insert(:team, league_node: node).id, [node.id, parent.id, root.id]}
    end)
    |> Enum.sort_by(fn {id, _} -> id end)

    resulting_team_ids_with_ancestors = root
    |> LeagueNode.teams_with_ancestry
    |> Stream.map(fn {team, ancestors} -> {team.id, ancestors} end)
    |> Enum.sort_by(fn {id, _} -> id end)

    assert resulting_team_ids_with_ancestors == team_ids_with_ancestors
  end
end
