defmodule CounselorBridge.Event do
  use Ecto.Schema

  alias CounselorBridge.Repo

  schema "events" do
    belongs_to :interaction, CounselorBridge.Interaction

    field :body, :string
    field :message_id, :string # 34 character unique id

    timestamps(inserted_at: :created_at)
  end

  def create(interaction, %{message_id: message_id, content: content}) do
    %__MODULE__{
      interaction_id: interaction.id,
      message_id: message_id,
      content: content
    }
    |> Repo.insert
  end
end
