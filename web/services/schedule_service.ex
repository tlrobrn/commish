defmodule Commish.ScheduleService do
  alias Commish.Repo

  def teams_to_schedule(node = %Commish.LeagueNode{}) do
    teams_with_ancestry_until_node = node
    |> all_teams_with_ancestry
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

  defp all_teams_with_ancestry(node) do
    Repo.preload(node, :teams).teams
    |> Stream.map(&({&1, [node.id | node.ancestors]}))
    |> Stream.concat(Commish.LeagueNode.teams_with_ancestry(node))
  end
end
