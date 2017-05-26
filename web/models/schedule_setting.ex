defmodule Commish.ScheduleSetting do
  use Commish.Web, :model

  schema "schedule_settings" do
    field :games_to_play, {:array, :integer}
    belongs_to :league_node, Commish.LeagueNode

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    league_node = Map.get(params, :league_node) || Map.get(params, "league_node")

    struct
    |> cast(params, [:games_to_play])
    |> attach_node(league_node)
    |> validate_required([:games_to_play])
    |> foreign_key_constraint(:league_node_id)
  end
end
