defmodule AdvocateBridge.Event do
  use Ecto.Schema

  alias AdvocateBridge.Repo

  schema "events" do
    belongs_to :interaction, AdvocateBridge.Interaction

    field :content, :string
    field :message_id, :string # 34 character unique id

    timestamps(inserted_at: :created_at)
  end

  def create(interaction, %{message_id: message_id, content: content}) do
    case Repo.insert(%__MODULE__{interaction_id: interaction.id, message_id: message_id, content: content}) do
      {:ok, event} -> event
      _ -> %__MODULE__{}
    end
  end
end
