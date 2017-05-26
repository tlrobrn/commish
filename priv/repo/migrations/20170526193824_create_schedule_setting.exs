defmodule Commish.Repo.Migrations.CreateScheduleSetting do
  use Ecto.Migration

  def change do
    create table(:schedule_settings) do
      add :games_to_play, {:array, :integer}, null: false, default: []
      add :league_node_id, references(:league_nodes, on_delete: :delete_all)

      timestamps()
    end
    create index(:schedule_settings, [:league_node_id])

  end
end
