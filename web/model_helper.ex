defmodule Commish.ModelHelper do
  import Ecto.Changeset

  def attach_assoc(struct, _name, nil), do: struct
  def attach_assoc(struct, name, assoc) do
    struct |> put_assoc(name, assoc)
  end

  def get_indifferent_key(map = %{}, key) do
    Map.get(map, key) || Map.get(map, Atom.to_string(key))
  end
end
