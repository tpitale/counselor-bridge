defmodule AdvocateBridge.Bridge.ChannelHandler do
  use GenEvent

  def handle_event({:event, event}, _state) do
    IO.puts "handling event"
    IO.inspect event

    AdvocateBridge.InteractionsChannel.broadcast_event(event)

    {:ok, nil}
  end
end
