defmodule Commish.ScheduleSettingTest do
  use Commish.ModelCase

  alias Commish.ScheduleSetting

  @valid_attrs %{games_to_play: []}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ScheduleSetting.changeset(%ScheduleSetting{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ScheduleSetting.changeset(%ScheduleSetting{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset associates a LeagueNode if passed" do
    node = insert(:league_node)
    schedule_setting = ScheduleSetting.changeset(%ScheduleSetting{}, %{games_to_play: [2], league_node: node})
    |> Repo.insert!

    assert schedule_setting.league_node_id == node.id
  end

  test "changeset associates a LeagueNode if passed with string key" do
    node = insert(:league_node)
    schedule_setting = ScheduleSetting.changeset(%ScheduleSetting{}, %{"games_to_play" => [], "league_node" => node})
    |> Repo.insert!

    assert schedule_setting.league_node_id == node.id
  end

  test "changeset is invalid if the node doesn't exist" do
    node = insert(:league_node)
    changeset = ScheduleSetting.changeset(%ScheduleSetting{}, %{"games_to_play" => [], "league_node" => node})
    assert changeset.valid?

    Repo.delete!(node)
    {:error, changeset} = Repo.insert(changeset)

    refute changeset.valid?
  end

  test "schedule is deleted if its node is deleted" do
    node = insert(:league_node)
    insert(:schedule_setting, league_node: node)

    Repo.delete!(node)

    assert Repo.all(ScheduleSetting) |> Enum.count == 0
  end

  test "schedule is deleted if its tournament_configuration is deleted" do
    tournament_configuration = insert(:tournament_configuration)
    insert(:schedule_setting, tournament_configuration: tournament_configuration)

    Repo.delete!(tournament_configuration)

    assert Repo.all(ScheduleSetting) |> Enum.count == 0
  end
end
