defmodule RatemynewsWeb.VoteController do
  use RatemynewsWeb, :controller
  alias Ratemynews.Voters
  alias Ratemynews.Broadcasters.Vote
  alias Ratemynews.Broadcasters

  def cast_vote(conn, %{"broadcaster_id" => broadcaster_id, "vote_type" => vote_type}) do
    user_id = conn.assigns.current_user.id
    broadcaster = Broadcasters.get_broadcaster!(broadcaster_id)

    case Voters.get_vote(user_id, broadcaster_id) do
      nil ->
        Voters.create_vote(%{user_id: user_id, broadcaster_id: broadcaster_id, vote_type: vote_type})
        Voters.increment_vote_count(broadcaster, vote_type)

      %Vote{vote_type: ^vote_type} ->
        Voters.delete_vote(user_id, broadcaster_id)
        Voters.decrement_vote_count(broadcaster, vote_type)

      %Vote{} ->
        Voters.update_vote(user_id, broadcaster_id, vote_type)
        Voters.increment_vote_count(broadcaster, vote_type)
        Voters.decrement_vote_count(broadcaster, opposite_vote_type(vote_type))
    end

    redirect(conn, to: "/home")
  end

  defp opposite_vote_type("upvote"), do: "downvote"
  defp opposite_vote_type("downvote"), do: "upvote"
end
