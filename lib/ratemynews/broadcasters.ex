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
  def list_broadcasters(page, per_page \\ 50) do
    Broadcaster
    |> order_by([b], desc: b.upvotes)
    |> limit(^per_page)
    |> offset(^((page - 1) * per_page))
    |> Repo.all()
  end

  @doc """
  Returns the total count of broadcasters

  ## Examples

      iex> count_broadcasters()
      10
  """
  def count_broadcasters do
   Repo.aggregate(Broadcaster, :count, :id)
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
    |> case do
      {:ok, broadcaster} ->
        Phoenix.PubSub.broadcast(
          Ratemynews.PubSub,
          "broadcasters",
          {:broadcaster_created, broadcaster}
        )

        {:ok, broadcaster}

      {:error, _} = error ->
        error
    end
  end

  def get_broadcaster!(id) do
    Repo.get!(Broadcaster, id)
  end
end
