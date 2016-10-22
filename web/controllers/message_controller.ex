defmodule CounselorBridge.MessageController do
  use CounselorBridge.Web, :controller

  def create(conn, params) do
    IO.inspect params

    render conn
  end
end
