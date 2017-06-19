defmodule Commish.ScheduleService do
  alias Commish.{LeagueNode, Repo, ScheduleSetting, TournamentConfiguration}

  def schedule_tournament(configuration = %TournamentConfiguration{}) do
    Repo.preload(configuration, :schedule_settings).schedule_settings
    |> Enum.flat_map(&schedule_games/1)
  end

  def schedule_games(settings = %ScheduleSetting{games_to_play: [games_to_play]}) when rem(games_to_play, 2) == 0 do
    home_games_to_play = div(games_to_play, 2)

    Repo.preload(settings, :league_node).league_node
    |> teams_to_schedule
    |> Enum.flat_map(&create_games(&1, home_games_to_play))
  end

  def teams_to_schedule(node = %LeagueNode{}) do
    teams_with_ancestry_until_node = node
    |> LeagueNode.teams_with_ancestry
    |> Stream.map(fn {team, ancestry} ->
      ancestor_set = ancestry
      |> Stream.take_while(&(&1 != node.id))
      |> MapSet.new

      {team, ancestor_set}
    end)

    teams_with_ancestry_until_node
    |> Stream.map(fn {team, ancestry} ->
      cousins = teams_with_ancestry_until_node
      |> Stream.filter_map(
        fn {_, a} -> MapSet.disjoint?(ancestry, a) end,
        fn {t, _} -> t.id end
      )
      |> Enum.reject(&(&1 == team.id))

      {team.id, cousins}
    end)
    |> Stream.reject(fn {_, opponents} -> Enum.empty?(opponents) end)
    |> Enum.into(%{})
  end

  defp create_games({team, opponents}, count) do
    opponents
    |> Enum.flat_map(&create_games_for_teams(team, &1, count))
  end

  defp create_games_for_teams(home_team_id, away_team_id, count) do
    do_create_games_for_teams(home_team_id, away_team_id, count, [])
  end

  defp do_create_games_for_teams(_home_team_id, _away_team_id, 0, games), do: games
  defp do_create_games_for_teams(home_team_id, away_team_id, count, games) do
    game = {home_team_id, away_team_id}
    do_create_games_for_teams(home_team_id, away_team_id, count - 1, [game | games])
  end
end
