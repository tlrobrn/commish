defmodule Commish.LeagueNodeControllerTest do
  use Commish.ConnCase

  alias Commish.LeagueNode
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{name: nil}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, league_node_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing league nodes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, league_node_path(conn, :new)
    assert html_response(conn, 200) =~ "New league node"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, league_node_path(conn, :create), league_node: @valid_attrs
    assert redirected_to(conn) == league_node_path(conn, :index)
    assert Repo.get_by(LeagueNode, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, league_node_path(conn, :create), league_node: @invalid_attrs
    assert html_response(conn, 200) =~ "New league node"
  end

  test "shows chosen resource", %{conn: conn} do
    league_node = insert(:league_node)
    conn = get conn, league_node_path(conn, :show, league_node)
    assert html_response(conn, 200) =~ "Show league node"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, league_node_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    league_node = insert(:league_node)
    conn = get conn, league_node_path(conn, :edit, league_node)
    assert html_response(conn, 200) =~ "Edit league node"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    league_node = insert(:league_node)
    conn = put conn, league_node_path(conn, :update, league_node), league_node: @valid_attrs
    assert redirected_to(conn) == league_node_path(conn, :show, league_node)
    assert Repo.get_by(LeagueNode, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    league_node = insert(:league_node)
    conn = put conn, league_node_path(conn, :update, league_node), league_node: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit league node"
  end

  test "deletes chosen resource", %{conn: conn} do
    league_node = insert(:league_node)
    conn = delete conn, league_node_path(conn, :delete, league_node)
    assert redirected_to(conn) == league_node_path(conn, :index)
    refute Repo.get(LeagueNode, league_node.id)
  end
end
