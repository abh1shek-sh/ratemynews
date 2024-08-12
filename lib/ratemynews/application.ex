defmodule Ratemynews.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RatemynewsWeb.Telemetry,
      Ratemynews.Repo,
      {DNSCluster, query: Application.get_env(:ratemynews, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ratemynews.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ratemynews.Finch},
      # Start a worker by calling: Ratemynews.Worker.start_link(arg)
      # {Ratemynews.Worker, arg},
      # Start to serve requests, typically the last entry
      RatemynewsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ratemynews.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RatemynewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
