defmodule Commish.Factory do
  use ExMachina.Ecto, repo: Commish.Repo

  def league_node_factory do
    %Commish.LeagueNode{
      name: sequence("League"),
      ancestors: [],
    }
  end

  def with_ancestors(node, ancestors) do
    %{node | ancestors: ancestors, root_id: List.last(ancestors)}
  end

  def team_factory do
    %Commish.Team{
      name: sequence("Team"),
      league_node: build(:league_node),
    }
  end
end
