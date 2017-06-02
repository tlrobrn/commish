defmodule Commish.TournamentConfigurationController do
  use Commish.Web, :controller

  alias Commish.TournamentConfiguration

  def index(conn, _params) do
    tournament_configurations = Repo.all(TournamentConfiguration)
    render(conn, "index.html", tournament_configurations: tournament_configurations)
  end

  def new(conn, _params) do
    changeset = TournamentConfiguration.changeset(%TournamentConfiguration{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tournament_configuration" => tournament_configuration_params}) do
    changeset = TournamentConfiguration.changeset(%TournamentConfiguration{}, tournament_configuration_params)

    case Repo.insert(changeset) do
      {:ok, _tournament_configuration} ->
        conn
        |> put_flash(:info, "Tournament configuration created successfully.")
        |> redirect(to: tournament_configuration_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tournament_configuration = Repo.get!(TournamentConfiguration, id)
    render(conn, "show.html", tournament_configuration: tournament_configuration)
  end

  def edit(conn, %{"id" => id}) do
    tournament_configuration = Repo.get!(TournamentConfiguration, id)
    changeset = TournamentConfiguration.changeset(tournament_configuration)
    render(conn, "edit.html", tournament_configuration: tournament_configuration, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tournament_configuration" => tournament_configuration_params}) do
    tournament_configuration = Repo.get!(TournamentConfiguration, id)
    changeset = TournamentConfiguration.changeset(tournament_configuration, tournament_configuration_params)

    case Repo.update(changeset) do
      {:ok, tournament_configuration} ->
        conn
        |> put_flash(:info, "Tournament configuration updated successfully.")
        |> redirect(to: tournament_configuration_path(conn, :show, tournament_configuration))
      {:error, changeset} ->
        render(conn, "edit.html", tournament_configuration: tournament_configuration, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tournament_configuration = Repo.get!(TournamentConfiguration, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tournament_configuration)

    conn
    |> put_flash(:info, "Tournament configuration deleted successfully.")
    |> redirect(to: tournament_configuration_path(conn, :index))
  end
end
