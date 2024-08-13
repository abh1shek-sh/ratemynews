defmodule RatemynewsWeb.BroadcasterHTML do
  @moduledoc """
  This module contains pages rendered by BroadcasterController.

  See the `broadcaster_html` directory for all templates available.
  """
  use RatemynewsWeb, :html

  embed_templates "broadcaster_html/*"
end
