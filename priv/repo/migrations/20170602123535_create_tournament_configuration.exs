defmodule Commish.Repo.Migrations.CreateTournamentConfiguration do
  use Ecto.Migration

  def change do
    create table(:tournament_configurations) do
      add :name, :string
      add :league_node_id, references(:league_nodes, on_delete: :delete_all)

      timestamps()
    end
    create index(:tournament_configurations, [:league_node_id])

    alter table(:schedule_settings) do
      add :tournament_configuration_id, references(:tournament_configurations, on_delete: :delete_all)
    end
    create index(:schedule_settings, [:tournament_configuration_id])
  end
end
