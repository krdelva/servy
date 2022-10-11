defmodule Servy.PledgeServer do

  # def create_pledge(name, amount) do
  #   {:ok, id} = send_pledge_to_service(name, amount)

  #   # Cache the peldge
  #   [ {"larry", 10} ]
  # end

  # def recent_pledges do
  #   # Returns the most recent pledges (cache):application
  #   [ {"larry", 10} ]
  # end

  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  def listen_loop(state \\ []) do
    IO.puts "\nWaiting for a message..."

    receive do
      {:create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        new_state = [ {name, amount} | state ]
        IO.puts "#{name} pledged #{amount}!"
        IO.puts "New state is #{inspect new_state}"
        listen_loop(new_state)
      {sender, :recent_pledges} ->
        send sender, {:response, state}
        IO.puts "Sent pledges to #{inspect sender}!"
        listen_loop(state)
    end

  end

end


"""
THE OUTSIDE
"""

alias Servy.PledgeServer

pid = spawn(PledgeServer, :listen_loop, [[]])

send pid, {:create_pledge, "larry", 10}
send pid, {:create_pledge, "moe", 20}
send pid, {:create_pledge, "curly", 30}
send pid, {:create_pledge, "daisy", 40}
send pid, {:create_pledge, "grace", 50}

send pid, {self(), :recent_pledges}

receive do {:response, pledges} -> IO.inspect pledges end
