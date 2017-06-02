defmodule Commish.TournamentConfiguration do
  use Commish.Web, :model

  schema "tournament_configurations" do
    field :name, :string
    belongs_to :league_node, Commish.LeagueNode
    has_many :schedule_settings, Commish.ScheduleSetting, on_delete: :delete_all

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
  end
end
