defmodule Commish.Repo.Migrations.CreateLeagueNode do
  use Ecto.Migration

  def change do
    create table(:league_nodes) do
      add :name, :string, null: false
      add :ancestors, {:array, :integer}, null: false, default: []
      add :root_id, references(:league_nodes, on_delete: :delete_all)

      timestamps()
    end
    create index(:league_nodes, [:root_id])
    create index(:league_nodes, [:ancestors], using: :gin)

  end
end
