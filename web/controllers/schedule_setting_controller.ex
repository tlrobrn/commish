defmodule Commish.ScheduleSettingController do
  use Commish.Web, :controller

  alias Commish.ScheduleSetting

  def index(conn, _params) do
    schedule_settings = Repo.all(ScheduleSetting)
    render(conn, "index.html", schedule_settings: schedule_settings)
  end

  def new(conn, _params) do
    changeset = ScheduleSetting.changeset(%ScheduleSetting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"schedule_setting" => schedule_setting_params}) do
    changeset = ScheduleSetting.changeset(%ScheduleSetting{}, schedule_setting_params)

    case Repo.insert(changeset) do
      {:ok, _schedule_setting} ->
        conn
        |> put_flash(:info, "Schedule setting created successfully.")
        |> redirect(to: schedule_setting_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    schedule_setting = Repo.get!(ScheduleSetting, id)
    render(conn, "show.html", schedule_setting: schedule_setting)
  end

  def edit(conn, %{"id" => id}) do
    schedule_setting = Repo.get!(ScheduleSetting, id)
    changeset = ScheduleSetting.changeset(schedule_setting)
    render(conn, "edit.html", schedule_setting: schedule_setting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "schedule_setting" => schedule_setting_params}) do
    schedule_setting = Repo.get!(ScheduleSetting, id)
    changeset = ScheduleSetting.changeset(schedule_setting, schedule_setting_params)

    case Repo.update(changeset) do
      {:ok, schedule_setting} ->
        conn
        |> put_flash(:info, "Schedule setting updated successfully.")
        |> redirect(to: schedule_setting_path(conn, :show, schedule_setting))
      {:error, changeset} ->
        render(conn, "edit.html", schedule_setting: schedule_setting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    schedule_setting = Repo.get!(ScheduleSetting, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(schedule_setting)

    conn
    |> put_flash(:info, "Schedule setting deleted successfully.")
    |> redirect(to: schedule_setting_path(conn, :index))
  end
end
