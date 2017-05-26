defmodule Commish.Repo.Migrations.CreateTeam do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false
      add :league_node_id, references(:league_nodes, on_delete: :nilify_all)

      timestamps()
    end
    create index(:teams, [:league_node_id])

  end
end
