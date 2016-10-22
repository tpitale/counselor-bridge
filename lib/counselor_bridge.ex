defmodule CounselorBridge do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(CounselorBridge.Repo, []),
      # Start the endpoint when the application starts
      supervisor(CounselorBridge.Endpoint, []),
      # Start your own worker by calling: CounselorBridge.Worker.start_link(arg1, arg2, arg3)
      # worker(CounselorBridge.Worker, [arg1, arg2, arg3]),

      worker(GenEvent, [[name: :bridge_event_manager]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CounselorBridge.Supervisor]
    {:ok, pid} = Supervisor.start_link(children, opts)

    GenEvent.add_handler(:bridge_event_manager, CounselorBridge.Bridge.ChannelHandler, nil)

    {:ok, pid}
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CounselorBridge.Endpoint.config_change(changed, removed)
    :ok
  end
end
