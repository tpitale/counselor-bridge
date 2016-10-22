defmodule CounselorBridge.Interaction do
  use Ecto.Schema

  alias CounselorBridge.Repo

  import Ecto.Query, only: [from: 2, first: 2]

  schema "interactions" do
    belongs_to :client, CounselorBridge.Client

    field :status, :string

    timestamps(inserted_at: :created_at)
  end

  def open_for(client) do
    from(__MODULE__, where: [client_id: ^client.id, status: "open"])

    |> first(:created_at)
    |> Repo.one
  end

  def create(client) do
    case Repo.insert(%__MODULE__{client_id: client.id, status: "open"}) do
      {:ok, interaction} -> interaction
      _ -> nil
    end
  end
end
