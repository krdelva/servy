defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "caches the 3 most recent pledges and totals their amount" do
    PledgeServer.start

    PledgeServer.create_pledge("bob", 10)
    PledgeServer.create_pledge("lol", 20)
    PledgeServer.create_pledge("sol", 30)
    PledgeServer.create_pledge("chi", 40)
    PledgeServer.create_pledge("cha", 50)

    assert length(PledgeServer.recent_pledges) <= 3

    assert PledgeServer.total_pledged == 120
  end
end
