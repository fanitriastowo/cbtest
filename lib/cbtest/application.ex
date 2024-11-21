defmodule Cbtest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CbtestWeb.Telemetry,
      Cbtest.Repo,
      {DNSCluster, query: Application.get_env(:cbtest, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cbtest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cbtest.Finch},
      # Start a worker by calling: Cbtest.Worker.start_link(arg)
      # {Cbtest.Worker, arg},
      # Start to serve requests, typically the last entry
      CbtestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cbtest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CbtestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
