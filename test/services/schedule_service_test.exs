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
end
