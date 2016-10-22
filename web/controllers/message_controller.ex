defmodule CounselorBridge.MessageController do
  use CounselorBridge.Web, :controller

  def create(conn, params) do
    # https://www.twilio.com/docs/api/twiml/sms/twilio_request#synchronous
    # MessageSid
    # From => lookup/create client, lookup/create interaction, create event; notify with event
    # Body

    IO.inspect params

    client = CounselorBridge.Client.get(params["From"])

    {:ok, client} = if !client do
      CounselorBridge.Client.create(params["From"])
    end

    interaction = CounselorBridge.Interaction.open_for(client)

    {:ok, interaction} = if !interaction do
      CounselorBridge.Interaction.create(client)
    end

    {:ok, event} = CounselorBridge.Event.create(interaction, %{message_id: params["MessageSid"], content: params["Body"]})

    GenEvent.ack_notify(:bridge_event_manager, {:event, event})

    conn
    |> put_resp_content_type("text/xml")
    |> render("create.xml")
  end
end
