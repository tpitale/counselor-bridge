defmodule AdvocateBridge.ReleaseTasks do
  @moduledoc ~S"""
  Mix is not available in a built release. Instead we define the tasks here,
  and invoke it using the application script generated in the release:
  
      bin/advocate_bridge command Elixir.AdvocateBridge.ReleaseTasks create
      bin/advocate_bridge command Elixir.AdvocateBridge.ReleaseTasks migrate
      bin/advocate_bridge command Elixir.AdvocateBridge.ReleaseTasks seed
      bin/advocate_bridge command Elixir.AdvocateBridge.ReleaseTasks drop
  """

  import Logger

  @application :advocate_bridge

  def create do
    load_app()

    repos() |> Enum.each(&create/1)

    System.halt(0)
  end

  def create(repo) do
    info "Creating database for #{inspect repo}..."
    case repo.__adapter__.storage_up(repo.config) do
      :ok ->
        info "The database for #{inspect repo} has been created."
      {:error, :already_up} ->
        info "The database for #{inspect repo} has already been created."
      {:error, term} when is_binary(term) ->
        error "The database for #{inspect repo} couldn't be created, reason given: #{term}."
      {:error, term} ->
        error "The database for #{inspect repo} couldn't be created, reason given: #{inspect term}."
    end
  end

  def drop do
    load_app()

    repos() |> Enum.each(&drop/1)

    System.halt(0)
  end

  def drop(repo) do
    info "Dropping database for #{inspect repo}..."
    case repo.__adapter__.storage_down(repo.config) do
      :ok ->
        info "The database for #{inspect repo} has been dropped."
      {:error, :already_down} ->
        info "The database for #{inspect repo} has already been dropped."
      {:error, term} when is_binary(term) ->
        error "The database for #{inspect repo} couldn't be dropped, reason given: #{term}."
      {:error, term} ->
        error "The database for #{inspect repo} couldn't be dropped, reason given: #{inspect term}."
    end
  end

  def migrate do
    load_app()

    repos() |> Enum.each(&migrate/1)

    System.halt(0)
  end

  def migrate(repo) do
    start_repo(repo)
    migrations_path = Application.app_dir(@application, "priv/repo/migrations")
    info "Executing migrations for #{inspect repo} in #{migrations_path}:"
    migrations = Ecto.Migrator.run(repo, migrations_path, :up, all: true)
    info "Applied versions: #{inspect migrations}"
  end

  def seed do
    load_app()

    repos() |> Enum.each(&seed/1)

    System.halt(0)
  end

  def seed(repo) do
    start_repo(repo)
    info "Seeding data for #{inspect repo}.."
    # Put any needed seeding data here, or maybe run priv/repo/seeds.exs
  end
  
  defp start_applications(apps) do
    Enum.each(apps, fn app ->
      {:ok, _} = Application.ensure_all_started(app)
    end)
  end

  defp start_repo(repo) do
    load_app()

    {:ok, _} = repo.start_link()
  end

  defp load_app do
    start_applications([:logger, :postgrex, :ecto])

    :ok = Application.load(@application)
  end

  defp repos do
    Application.get_env(@application, :ecto_repos)
  end
end
