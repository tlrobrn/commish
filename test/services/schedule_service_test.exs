defmodule Commish.ScheduleServiceTest do
  use Commish.ModelCase

  alias Commish.ScheduleService

  test "teams_to_schedule returns an empty map if there are no teams to schedule for" do
    root = insert(:league_node)
    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    [first_child, second_child] = for _ <- 1..2 do
      build(:league_node) |> with_ancestors([parent.id, root.id]) |> insert
    end

    _first_teams = for _ <- 1..2, do: insert(:team, league_node: first_child)
    _second_teams = for _ <- 1..2, do: insert(:team, league_node: second_child)

    assert ScheduleService.teams_to_schedule(root) == %{}
  end

  test "teams_to_schedule returns all of a node's direct teams" do
    root = insert(:league_node)
    first_team = insert(:team, league_node: root)
    second_team = insert(:team, league_node: root)
    third_team = insert(:team, league_node: root)

    mapping = ScheduleService.teams_to_schedule(root)

    assert mapping[first_team.id] |> Enum.sort == [second_team.id, third_team.id]
    assert mapping[second_team.id] |> Enum.sort == [first_team.id, third_team.id]
    assert mapping[third_team.id] |> Enum.sort == [first_team.id, second_team.id]
  end

  test "teams_to_schedule returns a map of teams to their desired opponents" do
    root = insert(:league_node)
    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    [first_child, second_child] = for _ <- 1..2 do
      build(:league_node) |> with_ancestors([parent.id, root.id]) |> insert
    end

    first_teams = for _ <- 1..2, do: insert(:team, league_node: first_child)
    second_teams = for _ <- 1..2, do: insert(:team, league_node: second_child)

    mapping = ScheduleService.teams_to_schedule(parent)

    first_teams |> Enum.each(fn team ->
      assert mapping[team.id] |> Enum.sort == second_teams |> Stream.map(&(&1.id)) |> Enum.sort
    end)

    second_teams |> Enum.each(fn team ->
      assert mapping[team.id] |> Enum.sort == first_teams |> Stream.map(&(&1.id)) |> Enum.sort
    end)
  end

  test "schedule_tournament schedules all games in a tournament" do
    root = insert(:league_node)
    tournament_configuration = insert(:tournament_configuration, league_node: root)

    parent = build(:league_node) |> with_ancestors([root.id]) |> insert
    [first_child, second_child] = for _ <- 1..2 do
      node = build(:league_node) |> with_ancestors([parent.id, root.id]) |> insert

      insert(
        :schedule_setting,
        league_node: node,
        tournament_configuration: tournament_configuration,
        games_to_play: [4],
      )

      node
    end
    _first_teams = for _ <- 1..2, do: insert(:team, league_node: first_child)
    _second_teams = for _ <- 1..2, do: insert(:team, league_node: second_child)

    games = ScheduleService.schedule_tournament(tournament_configuration)
    assert length(games) == 8
  end
end
