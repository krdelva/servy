defmodule Servy.VideoCam do

  def get_snapshot(filename) do
    :timer.sleep(1000)
    filename <> "-extension.jpg"
  end


end
