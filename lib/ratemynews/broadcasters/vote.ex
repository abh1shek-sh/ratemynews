defmodule Ratemynews.Broadcasters.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :vote_type, :string
    belongs_to :user, Ratemynews.Accounts.User
    belongs_to :broadcaster, Ratemynews.Broadcasters.Broadcaster

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:user_id, :broadcaster_id, :vote_type])
    |> validate_required([:user_id, :broadcaster_id, :vote_type])
    |> unique_constraint([:user_id, :broadcaster_id])
  end
end
