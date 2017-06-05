defmodule Commish.LeagueNode do
  use Commish.Web, :model
  alias Commish.Repo

  schema "league_nodes" do
    field :name, :string
    field :ancestors, {:array, :integer}
    belongs_to :root, Commish.LeagueNode
    has_many :teams, Commish.Team, on_delete: :nilify_all
    has_many :tournament_configurations, Commish.TournamentConfiguration, on_delete: :delete_all

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

  def children(node) do
    node |> children_query |> Repo.all
  end
  defp children_query(node) do
    child_ancestors = [node.id | node.ancestors]
    __MODULE__ |> where(ancestors: ^child_ancestors)
  end

  def descendants(node) do
    node |> descendants_query |> Repo.all
  end
  defp descendants_query(node) do
    __MODULE__ |> where([n], fragment("? = ANY(?)", ^node.id, n.ancestors))
  end

  def teams_with_ancestry(node) do
    node
    |> teams_with_ancestry_query
    |> Repo.all
  end
  defp teams_with_ancestry_query(node) do
    node
    |> descendants_query
    |> or_where([n], n.id == ^node.id)
    |> join(:inner, [n], t in assoc(n, :teams))
    |> select([n, t], {t, fragment("?||?", n.id, n.ancestors)})
  end

  defp generate_ancestry(params = %{parent: parent = %__MODULE__{}}) do
    params
    |> Map.put_new(:ancestors, [parent.id | parent.ancestors])
    |> Map.put_new(:root_id, parent.root_id || parent.id)
  end
  defp generate_ancestry(params = %{"parent" => parent = %__MODULE__{}}) do
    params
    |> Map.put_new("ancestors", [parent.id | parent.ancestors])
    |> Map.put_new("root_id", parent.root_id || parent.id)
  end
  defp generate_ancestry(params), do: params
end
