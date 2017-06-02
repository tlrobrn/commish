defmodule Commish.TournamentConfigurationControllerTest do
  use Commish.ConnCase

  alias Commish.TournamentConfiguration
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tournament_configuration_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing tournament configurations"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, tournament_configuration_path(conn, :new)
    assert html_response(conn, 200) =~ "New tournament configuration"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, tournament_configuration_path(conn, :create), tournament_configuration: @valid_attrs
    assert redirected_to(conn) == tournament_configuration_path(conn, :index)
    assert Repo.get_by(TournamentConfiguration, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, tournament_configuration_path(conn, :create), tournament_configuration: @invalid_attrs
    assert html_response(conn, 200) =~ "New tournament configuration"
  end

  test "shows chosen resource", %{conn: conn} do
    tournament_configuration = Repo.insert! %TournamentConfiguration{}
    conn = get conn, tournament_configuration_path(conn, :show, tournament_configuration)
    assert html_response(conn, 200) =~ "Show tournament configuration"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, tournament_configuration_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    tournament_configuration = Repo.insert! %TournamentConfiguration{}
    conn = get conn, tournament_configuration_path(conn, :edit, tournament_configuration)
    assert html_response(conn, 200) =~ "Edit tournament configuration"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    tournament_configuration = Repo.insert! %TournamentConfiguration{}
    conn = put conn, tournament_configuration_path(conn, :update, tournament_configuration), tournament_configuration: @valid_attrs
    assert redirected_to(conn) == tournament_configuration_path(conn, :show, tournament_configuration)
    assert Repo.get_by(TournamentConfiguration, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    tournament_configuration = Repo.insert! %TournamentConfiguration{}
    conn = put conn, tournament_configuration_path(conn, :update, tournament_configuration), tournament_configuration: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit tournament configuration"
  end

  test "deletes chosen resource", %{conn: conn} do
    tournament_configuration = Repo.insert! %TournamentConfiguration{}
    conn = delete conn, tournament_configuration_path(conn, :delete, tournament_configuration)
    assert redirected_to(conn) == tournament_configuration_path(conn, :index)
    refute Repo.get(TournamentConfiguration, tournament_configuration.id)
  end
end
