defmodule Servy.VideoCam do

  def get_snapshot(filename) do
    :timer.sleep(1000)
    filename <> "-snapshot-#{:rand.uniform(1000)}.jpg"
  end


end
