defmodule RatemynewsWeb.BroadcasterController do
  use RatemynewsWeb, :controller

  alias Ratemynews.Broadcasters
  alias Ratemynews.Broadcasters.Broadcaster

  def new(conn, _params) do
    changeset = Broadcasters.change_broadcaster(%Broadcaster{},%{})
    IO.inspect(changeset)
    render(conn, :broadcaster, changeset: changeset)
  end

  def create(conn, %{"broadcaster" => broadcaster_params}) do
    case Broadcasters.create_broadcaster(broadcaster_params) do
      {:ok, _broadcaster} ->
        conn
        |> put_flash(:info, "Broadcaster created successfully.")
        |> redirect(to: "/home")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :broadcaster, changeset: changeset)
    end
  end
end
