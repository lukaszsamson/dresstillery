defmodule DresstilleryWeb.ChangesetViewTest do
  use DresstilleryWeb.ConnCase, async: true

  alias Dresstillery.Administration.BackofficeUser

  import Phoenix.View

  test "renders 422.json" do
    changeset = BackofficeUser.changeset(%BackofficeUser{}, %{login: ""})

    assert render(DresstilleryWeb.ChangesetView, "error.json", [changeset: changeset]) ==
           %{errors: %{login: ["can't be blank"]}}
  end

end
