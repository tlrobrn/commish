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
    root_id = params
    |> Map.get(:ancestors, [])
    |> List.last

    struct
    |> cast(params, [:name, :ancestors])
    |> change(root_id: root_id)
    |> validate_required([:name])
    |> foreign_key_constraint(:root_id)
  end
end
