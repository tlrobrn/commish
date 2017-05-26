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
end
