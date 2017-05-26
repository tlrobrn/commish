defmodule Commish.TeamTest do
  use Commish.ModelCase

  alias Commish.Team

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Team.changeset(%Team{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Team.changeset(%Team{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset associates a LeagueNode if passed" do
    node = insert(:league_node)
    team = Team.changeset(%Team{}, %{name: "team", league_node: node})
    |> Repo.insert!

    assert team.league_node_id == node.id
  end

  test "changeset associates a LeagueNode if passed with string key" do
    node = insert(:league_node)
    team = Team.changeset(%Team{}, %{"name" => "team", "league_node" => node})
    |> Repo.insert!

    assert team.league_node_id == node.id
  end

  test "changeset is invalid if the node doesn't exist" do
    node = insert(:league_node)
    changeset = Team.changeset(%Team{}, %{"name" => "team", "league_node" => node})
    assert changeset.valid?

    Repo.delete!(node)
    {:error, changeset} = Repo.insert(changeset)

    refute changeset.valid?
  end

  test "league_node_id is set to NULL if the node is deleted" do
    team = insert(:team)
    assert team.league_node_id != nil

    Repo.get!(Commish.LeagueNode, team.league_node_id) |> Repo.delete!
    team = Repo.all(Team) |> hd

    assert team.league_node_id == nil
  end
end
