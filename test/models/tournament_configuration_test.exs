defmodule Commish.TournamentConfigurationTest do
  use Commish.ModelCase

  alias Commish.TournamentConfiguration

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TournamentConfiguration.changeset(%TournamentConfiguration{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TournamentConfiguration.changeset(%TournamentConfiguration{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "configuration is deleted if its node is deleted" do
    node = insert(:league_node)
    insert(:tournament_configuration, league_node: node)

    Repo.delete!(node)

    assert Repo.all(TournamentConfiguration) |> Enum.count == 0
  end

  test "changeset associates passed LeagueNode" do
    node = insert(:league_node)
    tournament_configuration = TournamentConfiguration.changeset(%TournamentConfiguration{}, %{name: "some name", league_node: node})
    |> Repo.insert!

    assert tournament_configuration.league_node_id == node.id
  end
end
