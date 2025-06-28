defmodule ArtisticElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ArtisticElixirWeb.Telemetry,
      ArtisticElixir.Repo,
      {DNSCluster, query: Application.get_env(:artistic_elixir, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ArtisticElixir.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ArtisticElixir.Finch},
      # Start a worker by calling: ArtisticElixir.Worker.start_link(arg)
      # {ArtisticElixir.Worker, arg},
      # Start to serve requests, typically the last entry
      ArtisticElixirWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArtisticElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArtisticElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
