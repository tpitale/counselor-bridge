defmodule CounselorBridge.MessageController do
  use CounselorBridge.Web, :controller

  def create(conn, params) do
    # https://www.twilio.com/docs/api/twiml/sms/twilio_request#synchronous
    # MessageSid
    # From => lookup/create client, lookup/create interaction, create event; notify with event
    # Body

    IO.inspect params

    # send welcome message if we don't have a client for them yet
    if !CounselorBridge.Client.get(params["From"]) do
      ExTwilio.Message.create(from: "+18556251700", to: params["From"], body: "Thanks for contacting Advocate, a 100% free 24/7 support service for St. Louis residents. Feel free to ask me any question: from utility bill issues to landlord disputes, emergency shelter, food services and more.")
    end

    client = CounselorBridge.Client.get(params["From"]) ||
              CounselorBridge.Client.create(params["From"])

    interaction = CounselorBridge.Interaction.open_for(client) ||
                    CounselorBridge.Interaction.create(client)

    event = CounselorBridge.Event.create(interaction, %{message_id: params["MessageSid"], content: params["Body"]})

    GenEvent.ack_notify(:bridge_event_manager, {:event, event})

    conn
    |> put_resp_content_type("text/xml")
    |> render("create.xml")
  end
end
