defmodule Commish.Team do
  use Commish.Web, :model

  schema "teams" do
    field :name, :string
    belongs_to :league_node, Commish.LeagueNode

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    league_node = get_indifferent_key(params, :league_node)

    struct
    |> cast(params, [:name])
    |> attach_assoc(:league_node, league_node)
    |> validate_required([:name])
    |> foreign_key_constraint(:league_node_id)
  end
end
