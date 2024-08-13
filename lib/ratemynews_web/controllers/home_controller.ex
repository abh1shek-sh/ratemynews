defmodule RatemynewsWeb.HomeController do
  use RatemynewsWeb, :controller

  alias Ratemynews.Broadcasters

  def index(conn, _params) do
    broadcasters = Broadcasters.list_broadcasters()
   conn
  |> assign(:page_title, "Rate My News")
  |> render(:index, broadcasters: broadcasters)
  end
end
