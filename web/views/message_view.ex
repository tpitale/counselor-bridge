defmodule CounselorBridge.MessageView do
  use CounselorBridge.Web, :view

  def render("create.xml", _content) do
    # empty response
    "<?xml version=\"1.0\" encoding=\"UTF-8\" ?><Response></Response>"
  end
end
