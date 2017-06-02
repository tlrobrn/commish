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

  def tournament_configuration_factory do
    %Commish.TournamentConfiguration{
      name: sequence("TournamentConfiguration"),
      league_node: build(:league_node),
    }
  end

  def schedule_setting_factory do
    %Commish.ScheduleSetting{
      games_to_play: [2],
      league_node: build(:league_node),
      tournament_configuration: build(:tournament_configuration),
    }
  end
end
