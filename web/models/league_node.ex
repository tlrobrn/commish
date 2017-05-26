defmodule Commish.LeagueNode do
  use Commish.Web, :model

  schema "league_nodes" do
    field :name, :string
    field :ancestors, {:array, :integer}
    belongs_to :root, Commish.LeagueNode

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    updated_params = generate_ancestry(params)

    struct
    |> cast(updated_params, [:name, :ancestors, :root_id])
    |> validate_required([:name])
    |> foreign_key_constraint(:root_id)
  end

  defp generate_ancestry(params = %{parent: parent = %Commish.LeagueNode{}}) do
    params
    |> Map.put_new(:ancestors, [parent.id | parent.ancestors])
    |> Map.put_new(:root_id, parent.root_id || parent.id)
  end
  defp generate_ancestry(params), do: params
end
