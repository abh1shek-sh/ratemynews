defmodule RatemynewsWeb.HomeLive do
  use RatemynewsWeb, :live_view
  alias Ratemynews.Voters
  alias Ratemynews.Broadcasters
  alias Ratemynews.Broadcasters.Vote

  def on_mount(:default, _params, session, socket) do
    {:cont, assign(socket, :current_user, session["current_user"])}
  end

  def mount(_params, session, socket) do
    current_user = get_current_user(session)
    broadcasters = Broadcasters.list_broadcasters()

    # Retrieve the user's votes
    user_votes = Voters.get_user_votes(current_user.id)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Ratemynews.PubSub, "votes")
      Phoenix.PubSub.subscribe(Ratemynews.PubSub, "broadcasters")
    end

    {:ok,
     assign(socket,
       broadcasters: broadcasters,
       current_user: current_user,
       user_vote: user_votes
     )}
  end

  defp get_current_user(session) do
    user_token = session["user_token"]
    Ratemynews.Accounts.get_user_by_session_token(user_token)
  end

  def handle_event(
        "vote",
        %{"broadcaster_id" => broadcaster_id, "vote_type" => vote_type},
        socket
      ) do
    IO.puts("vote event")
    user_id = socket.assigns.current_user.id
    broadcaster = Broadcasters.get_broadcaster!(broadcaster_id)

    case Voters.get_vote(user_id, broadcaster_id) do
      nil ->
        Voters.create_vote(%{
          user_id: user_id,
          broadcaster_id: broadcaster_id,
          vote_type: vote_type
        })

        Voters.increment_vote_count(broadcaster, vote_type)

      %Vote{vote_type: ^vote_type} ->
        Voters.delete_vote(user_id, broadcaster_id)
        Voters.decrement_vote_count(broadcaster, vote_type)

      %Vote{} ->
        Voters.update_vote(user_id, broadcaster_id, vote_type)
        Voters.increment_vote_count(broadcaster, vote_type)
        Voters.decrement_vote_count(broadcaster, opposite_vote_type(vote_type))
    end

    Phoenix.PubSub.broadcast(
      Ratemynews.PubSub,
      "votes",
      {:vote_updated, broadcaster_id}
    )

    {:noreply, update_broadcasters(socket)}
  end

  def handle_info({:vote_updated, _broadcaster_id}, socket) do
    ## log the event in the conosle
    IO.puts("vote updated")
    broadcasters = Broadcasters.list_broadcasters()
    {:noreply, assign(socket, broadcasters: broadcasters)}
  end

  def handle_info({:broadcaster_created, _broadcaster}, socket) do
    broadcasters = Broadcasters.list_broadcasters()
    {:noreply, assign(socket, broadcasters: broadcasters)}
  end

  defp update_broadcasters(socket) do
    broadcasters = Broadcasters.list_broadcasters()

    user_votes =
      Enum.reduce(broadcasters, %{}, fn broadcaster, acc ->
        vote = Voters.get_vote(socket.assigns.current_user.id, broadcaster.id)
        Map.put(acc, broadcaster.id, vote && vote.vote_type)
      end)

    assign(socket, broadcasters: broadcasters, user_vote: user_votes)
  end

  defp opposite_vote_type("upvote"), do: "downvote"
  defp opposite_vote_type("downvote"), do: "upvote"
end
