defmodule Commish.ScheduleSettingControllerTest do
  use Commish.ConnCase

  alias Commish.ScheduleSetting
  @valid_attrs %{games_to_play: []}
  @invalid_attrs %{games_to_play: nil}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, schedule_setting_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing schedule settings"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, schedule_setting_path(conn, :new)
    assert html_response(conn, 200) =~ "New schedule setting"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, schedule_setting_path(conn, :create), schedule_setting: @valid_attrs
    assert redirected_to(conn) == schedule_setting_path(conn, :index)
    assert Repo.get_by(ScheduleSetting, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, schedule_setting_path(conn, :create), schedule_setting: @invalid_attrs
    assert html_response(conn, 200) =~ "New schedule setting"
  end

  test "shows chosen resource", %{conn: conn} do
    schedule_setting = Repo.insert! %ScheduleSetting{}
    conn = get conn, schedule_setting_path(conn, :show, schedule_setting)
    assert html_response(conn, 200) =~ "Show schedule setting"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, schedule_setting_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    schedule_setting = Repo.insert! %ScheduleSetting{}
    conn = get conn, schedule_setting_path(conn, :edit, schedule_setting)
    assert html_response(conn, 200) =~ "Edit schedule setting"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    schedule_setting = Repo.insert! %ScheduleSetting{}
    conn = put conn, schedule_setting_path(conn, :update, schedule_setting), schedule_setting: @valid_attrs
    assert redirected_to(conn) == schedule_setting_path(conn, :show, schedule_setting)
    assert Repo.get_by(ScheduleSetting, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    schedule_setting = Repo.insert! %ScheduleSetting{}
    conn = put conn, schedule_setting_path(conn, :update, schedule_setting), schedule_setting: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit schedule setting"
  end

  test "deletes chosen resource", %{conn: conn} do
    schedule_setting = Repo.insert! %ScheduleSetting{}
    conn = delete conn, schedule_setting_path(conn, :delete, schedule_setting)
    assert redirected_to(conn) == schedule_setting_path(conn, :index)
    refute Repo.get(ScheduleSetting, schedule_setting.id)
  end
end
