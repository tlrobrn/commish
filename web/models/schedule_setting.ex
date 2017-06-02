defmodule Commish.ScheduleSetting do
  use Commish.Web, :model

  schema "schedule_settings" do
    field :games_to_play, {:array, :integer}
    belongs_to :league_node, Commish.LeagueNode
    belongs_to :tournament_configuration, Commish.TournamentConfiguration

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    league_node = get_indifferent_key(params, :league_node)
    tournament_configuration = get_indifferent_key(params, :tournament_configuration)

    struct
    |> cast(params, [:games_to_play])
    |> attach_assoc(:league_node, league_node)
    |> attach_assoc(:tournament_configuration, tournament_configuration)
    |> validate_required([:games_to_play])
    |> foreign_key_constraint(:league_node_id)
  end
end
