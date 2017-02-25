defmodule AdvocateBridge.InteractionsChannel do
  use AdvocateBridge.Web, :channel

  # specific interaction for /interactions/:id
  def join("interactions:" <> interaction_id, payload, socket) do
    if authorized?(payload) do
      IO.inspect payload
      {:ok, "Streaming event #{interaction_id}", socket}
    else
      IO.puts "error joining channel"
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("interactions", payload, socket) do
    if authorized?(payload) do
      IO.inspect payload
      {:ok, "Streaming all events", socket}
    else
      IO.puts "error joining channel"
      {:error, %{reason: "unauthorized"}}
    end
  end


  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    # TODO: lookup User by key
    true
  end

  def broadcast_event(event) do
    payload = %{
      id: event.id,
      interaction_id: event.interaction_id,
      content: event.content
    }

    IO.puts "broadcasting event #{event.id} for interaction #{event.interaction_id}"

    # broadcast to both specific id and all
    # TODO: is there a better way
    AdvocateBridge.Endpoint.broadcast("interactions:#{event.interaction_id}", "event", payload)
    AdvocateBridge.Endpoint.broadcast("interactions", "event", payload)
  end
end
