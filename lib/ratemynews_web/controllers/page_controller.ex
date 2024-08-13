defmodule RatemynewsWeb.PageController do
  use RatemynewsWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: "/home")
  end
end
