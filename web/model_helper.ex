defmodule Commish.ModelHelper do
  import Ecto.Changeset

  def attach_node(struct, nil), do: struct
  def attach_node(struct, league_node) do
    struct |> put_assoc(:league_node, league_node)
  end
end
