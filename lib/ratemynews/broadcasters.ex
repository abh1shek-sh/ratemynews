defmodule Ratemynews.Broadcasters do
  import Ecto.Query, warn: false
  alias Ratemynews.Repo

  alias Ratemynews.Broadcasters.Broadcaster

  @doc """
  Returns the list of broadcasters.

  ## Examples

      iex> list_broadcasters()
      [%Broadcaster{}, ...]

  """
  def list_broadcasters do
    Repo.all(Broadcaster)
    |> Repo.preload(:votes)
  end
end
