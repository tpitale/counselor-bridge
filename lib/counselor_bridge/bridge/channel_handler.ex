defmodule CounselorBridge.Bridge.ChannelHandler do
  use GenEvent

  def handle_event({:event, event}, _state) do
    IO.puts "handling event"
    IO.inspect event

    CounselorBridge.InteractionsChannel.broadcast_event(event)

    {:ok, nil}
  end
end
