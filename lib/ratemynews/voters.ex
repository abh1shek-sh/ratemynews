defmodule Ratemynews.Voters do
  import Ecto.Query, warn: false
  alias Ratemynews.Repo
  alias Ratemynews.Broadcasters.Vote

  def get_vote(user_id, broadcaster_id) do
    Repo.get_by(Vote, user_id: user_id, broadcaster_id: broadcaster_id)
  end

  def create_vote(attrs) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  def delete_vote(user_id, broadcaster_id) do
    vote = get_vote(user_id, broadcaster_id)
    Repo.delete(vote)
  end

  def update_vote(user_id, broadcaster_id, vote_type) do
    vote = get_vote(user_id, broadcaster_id)
    vote
    |> Vote.changeset(%{vote_type: vote_type})
    |> Repo.update()
  end

  def increment_vote_count(broadcaster, vote_type) do
    changeset = case vote_type do
      "upvote" -> Ecto.Changeset.change(broadcaster, upvotes: broadcaster.upvotes + 1)
      "downvote" -> Ecto.Changeset.change(broadcaster, downvotes: broadcaster.downvotes + 1)
    end
    Repo.update(changeset)
  end

  def decrement_vote_count(broadcaster, vote_type) do
    changeset = case vote_type do
      "upvote" -> Ecto.Changeset.change(broadcaster, upvotes: broadcaster.upvotes - 1)
      "downvote" -> Ecto.Changeset.change(broadcaster, downvotes: broadcaster.downvotes - 1)
    end
    Repo.update(changeset)
  end
end
