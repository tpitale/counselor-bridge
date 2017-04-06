defmodule AdvocateBridge.MessageController do
  use AdvocateBridge.Web, :controller

  def create(conn, params) do
    # https://www.twilio.com/docs/api/twiml/sms/twilio_request#synchronous
    # MessageSid
    # From => lookup/create client, lookup/create interaction, create event; notify with event
    # Body
    # curl -d "From=+18005550123" -d "MessageSid=102991823" -d "Body=reply reply reply" http://localhost:3001/api/messages

    IO.inspect params

    client = AdvocateBridge.Client.get(params["From"]) ||
              AdvocateBridge.Client.create(params["From"])

    interaction = AdvocateBridge.Interaction.open_for(client) ||
                    AdvocateBridge.Interaction.create(client)

    event = AdvocateBridge.Event.create(interaction, %{message_id: params["MessageSid"], content: params["Body"]})

    GenEvent.ack_notify(:bridge_event_manager, {:event, event})

    conn
    |> put_resp_content_type("text/xml")
    |> render("create.xml")
  end
end
