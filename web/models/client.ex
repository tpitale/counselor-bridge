defmodule CounselorBridge.Client do
  use Ecto.Schema

  alias CounselorBridge.Repo

  import Ecto.Query, only: [from: 2, first: 1]

  schema "clients" do
    field :phone, :string

    timestamps(inserted_at: :created_at)
  end

  def get(phone) do
    from(__MODULE__, where: [phone: ^phone])

    |> first
    |> Repo.one
  end
end
