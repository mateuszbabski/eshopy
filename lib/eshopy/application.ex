defmodule Eshopy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Eshopy.Repo,
      # Start the Telemetry supervisor
      EshopyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Eshopy.PubSub},
      EshopyWeb.Presence,
      # Start the Endpoint (http/https)
      EshopyWeb.Endpoint
      # Start a worker by calling: Eshopy.Worker.start_link(arg)
      # {Eshopy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Eshopy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EshopyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
