defmodule RatemynewsWeb.BroadcasterLiveComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <tr id={"broadcaster-#{@broadcaster.id}"} class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
      <td class="py-4 px-6 flex items-center">
        <img src={@broadcaster.profile_image_url} alt={@broadcaster.name} class="w-10 h-10 rounded-full mr-3">
        <%= @broadcaster.name %>
      </td>
      <td class="py-4 px-6">
        <%= @broadcaster.mode_of_broadcast %>
      </td>
      <td class="py-4 px-6">
        <%= @broadcaster.origin %>
      </td>
      <td class="py-4 px-6">
        <%= @broadcaster.topics %>
      </td>
      <td class="py-4 px-6">
        <%= @broadcaster.upvotes %>
      </td>
      <td class="py-4 px-6">
        <%= @broadcaster.downvotes %>
      </td>
      <td class="py-4 px-6 flex">
        <button phx-click="vote" phx-value-broadcaster_id={@broadcaster.id} phx-value-vote_type="upvote" class="bg-green-500 text-white px-2 py-1 rounded mr-2">Upvote</button>
        <button phx-click="vote" phx-value-broadcaster_id={@broadcaster.id} phx-value-vote_type="downvote" class="bg-red-500 text-white px-2 py-1 rounded">Downvote</button>
      </td>
    </tr>
    """
  end
end
