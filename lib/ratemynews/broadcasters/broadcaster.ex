
defmodule Ratemynews.Broadcasters.Broadcaster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "broadcasters" do
    field :name, :string
    field :mode_of_broadcast, :string
    field :origin, :string
    field :topics, :string
    field :profile_image_url, :string
    field :social_media, :map, default: %{}

    has_many :votes, Ratemynews.Broadcasters.Vote

    timestamps()
  end

  @doc false
  def changeset(broadcaster, attrs) do
    broadcaster
    |> cast(attrs, [:name, :mode_of_broadcast, :origin, :topics, :profile_image_url, :social_media])
    |> validate_required([:name, :mode_of_broadcast, :origin, :topics, :social_media])
  end
end