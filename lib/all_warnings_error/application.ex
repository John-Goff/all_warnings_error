defmodule AllWarningsError.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AllWarningsErrorWeb.Telemetry,
      AllWarningsError.Repo,
      {DNSCluster, query: Application.get_env(:all_warnings_error, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AllWarningsError.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AllWarningsError.Finch},
      # Start a worker by calling: AllWarningsError.Worker.start_link(arg)
      # {AllWarningsError.Worker, arg},
      # Start to serve requests, typically the last entry
      AllWarningsErrorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AllWarningsError.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AllWarningsErrorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
