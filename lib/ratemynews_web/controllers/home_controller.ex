defmodule RatemynewsWeb.HomeController do
  use RatemynewsWeb, :controller

  alias Ratemynews.Broadcasters

  def index(conn, _params) do
    broadcasters = Broadcasters.list_broadcasters()
    render(conn, :index, broadcasters: broadcasters)
  end
end
