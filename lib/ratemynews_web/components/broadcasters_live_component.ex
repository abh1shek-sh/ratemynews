defmodule RatemynewsWeb.Components.BroadcasterLiveComponent do
  use Phoenix.LiveComponent
  @moduledoc """
  A live component to render a broadcaster row.
  """

def render(assigns) do
  ~H"""
  <tr class="flex flex-col flex-no-wrap sm:table-row bg-white border-b dark:bg-gray-800 dark:border-gray-700">
    <td class="py-4 px-6 flex items-center">
      <%= @broadcaster.name %>
    </td>
    <td class="py-4 px-6"><%= @broadcaster.mode_of_broadcast %></td>
    <td class="py-4 px-6"><%= @broadcaster.origin %></td>
    <td class="py-4 px-6"><%= @broadcaster.topics %></td>
    <td class="py-4 px-6"><%= @broadcaster.upvotes %></td>
    <td class="py-4 px-6"><%= @broadcaster.downvotes %></td>
    <td class="py-4 px-6 flex">
    <button
      phx-click="vote"
      phx-value-broadcaster_id={@broadcaster.id}
      phx-value-vote_type="upvote"
      class={["px-3 py-1 rounded text-white mr-2", (@user_vote == "upvote" && "bg-slate-400  ") || "bg-green-500"]}
    >
      Upvote
    </button>
    <button
      phx-click="vote"
      phx-value-broadcaster_id={@broadcaster.id}
      phx-value-vote_type="downvote"
      class={["px-3 py-1 rounded text-white", (@user_vote == "downvote" && "bg-slate-400  ") || "bg-red-500"]}
    >
      Downvote
    </button>
    </td>
  </tr>
  """
end
end
