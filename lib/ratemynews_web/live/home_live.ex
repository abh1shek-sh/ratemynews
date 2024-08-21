defmodule RatemynewsWeb.HomeLive do
  require Logger
  use RatemynewsWeb, :live_view
  alias Ratemynews.Voters
  alias Ratemynews.Broadcasters
  alias Ratemynews.Broadcasters.Vote

  @per_page 50

  def on_mount(:default, _params, session, socket) do
    {:cont, assign(socket, :current_user, session["current_user"])}
  end

  def mount(_params, %{"user_token" => user_token}, socket) when not is_nil(user_token) do
    current_user = get_current_user(user_token)
    broadcasters = Broadcasters.list_broadcasters(1, @per_page)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Ratemynews.PubSub, "votes")
      Phoenix.PubSub.subscribe(Ratemynews.PubSub, "broadcasters")
    end

    user_votes = Voters.get_user_votes(current_user.id)

    {:ok,
     assign(socket,
       broadcasters: broadcasters,
       current_user: current_user,
       user_vote: user_votes,
       page: 1,
       per_page: @per_page,
       total_count: Broadcasters.count_broadcasters()
     )}
  end

  def mount(_params, _socket, socket) do
    broadcasters = Broadcasters.list_broadcasters(1, @per_page)

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Ratemynews.PubSub, "votes")
      Phoenix.PubSub.subscribe(Ratemynews.PubSub, "broadcasters")
    end

    {:ok,
     assign(socket,
       broadcasters: broadcasters,
       current_user: nil,
       user_vote: %{},
       page: 1,
       per_page: @per_page,
      total_count: Broadcasters.count_broadcasters()
     )}
  end

  defp get_current_user(user_token) do
    Ratemynews.Accounts.get_user_by_session_token(user_token)
  end

  def handle_event(
        "vote",
        %{"broadcaster_id" => _broadcaster_id, "vote_type" => _vote_type},
        %{assigns: %{current_user: nil}} = socket
      ) do
    Logger.error("User not logged in", [])

    {:noreply,
     socket
     |> put_flash(:error, "You must be logged in to vote.")}
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

  def handle_event("change_page", %{"page" => page}, socket) do
    # Assuming 10 per page
    broadcasters = Broadcasters.list_broadcasters(String.to_integer(page), socket.assigns.per_page)
    {:noreply, assign(socket, broadcasters: broadcasters, page: String.to_integer(page))}
  end

  def handle_info({:vote_updated, _broadcaster_id}, socket) do
    ## log the event in the conosle
    IO.puts("vote updated")
    broadcasters = Broadcasters.list_broadcasters(socket.assigns.page, socket.assigns.per_page)
    {:noreply, assign(socket, broadcasters: broadcasters)}
  end

  def handle_info({:broadcaster_created, _broadcaster}, socket) do
    broadcasters = Broadcasters.list_broadcasters(socket.assigns.page, socket.assigns.per_page)
    {:noreply, assign(socket, broadcasters: broadcasters)}
  end

  defp update_broadcasters(socket) do
    broadcasters = Broadcasters.list_broadcasters(socket.assigns.page,@per_page)

    user_votes =
      Enum.reduce(broadcasters, %{}, fn broadcaster, acc ->
        vote = Voters.get_vote(socket.assigns.current_user.id, broadcaster.id)
        Map.put(acc, broadcaster.id, vote && vote.vote_type)
      end)

    assign(socket, broadcasters: broadcasters, user_vote: user_votes, total_count: Broadcasters.count_broadcasters())
  end

  defp opposite_vote_type("upvote"), do: "downvote"
  defp opposite_vote_type("downvote"), do: "upvote"
end
