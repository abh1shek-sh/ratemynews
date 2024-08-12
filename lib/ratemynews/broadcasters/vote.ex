
defmodule Ratemynews.Broadcasters.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :vote_type, :integer
    belongs_to :broadcaster, Ratemynews.Broadcasters.Broadcaster
    belongs_to :user, Ratemynews.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:vote_type, :broadcaster_id, :user_id])
    |> validate_required([:vote_type, :broadcaster_id, :user_id])
  end
end
