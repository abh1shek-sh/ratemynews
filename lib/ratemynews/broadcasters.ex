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

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking broadcaster changes.
  It can be used for creating or updating a broadcaster.
  """
  def change_broadcaster(%Broadcaster{} = broadcaster, attrs \\ %{}) do
    Broadcaster.changeset(broadcaster, attrs)
  end

  @doc """
  Creates a broadcaster.

  ## Examples

      iex> create_broadcaster(%{name: "Some Name"})
      {:ok, %Broadcaster{}}

      iex> create_broadcaster(%{name: nil})
      {:error, %Ecto.Changeset{}}

  """
  def create_broadcaster(attrs \\ %{}) do
    %Broadcaster{}
    |> Broadcaster.changeset(attrs)
    |> Repo.insert()
  end
end
