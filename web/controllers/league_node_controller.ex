defmodule Commish.LeagueNodeController do
  use Commish.Web, :controller

  alias Commish.LeagueNode

  def index(conn, _params) do
    league_nodes = Repo.all(LeagueNode)
    render(conn, "index.html", league_nodes: league_nodes)
  end

  def new(conn, _params) do
    changeset = LeagueNode.changeset(%LeagueNode{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"league_node" => league_node_params}) do
    changeset = LeagueNode.changeset(%LeagueNode{}, league_node_params)

    case Repo.insert(changeset) do
      {:ok, _league_node} ->
        conn
        |> put_flash(:info, "League node created successfully.")
        |> redirect(to: league_node_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    league_node = Repo.get!(LeagueNode, id)
    render(conn, "show.html", league_node: league_node)
  end

  def edit(conn, %{"id" => id}) do
    league_node = Repo.get!(LeagueNode, id)
    changeset = LeagueNode.changeset(league_node)
    render(conn, "edit.html", league_node: league_node, changeset: changeset)
  end

  def update(conn, %{"id" => id, "league_node" => league_node_params}) do
    league_node = Repo.get!(LeagueNode, id)
    changeset = LeagueNode.changeset(league_node, league_node_params)

    case Repo.update(changeset) do
      {:ok, league_node} ->
        conn
        |> put_flash(:info, "League node updated successfully.")
        |> redirect(to: league_node_path(conn, :show, league_node))
      {:error, changeset} ->
        render(conn, "edit.html", league_node: league_node, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    league_node = Repo.get!(LeagueNode, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(league_node)

    conn
    |> put_flash(:info, "League node deleted successfully.")
    |> redirect(to: league_node_path(conn, :index))
  end
end
