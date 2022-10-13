defmodule Servy.PledgeServer do


  #@process_name :pledge_server
  @process_name __MODULE__

  # Client Interface

  def start do
    IO.puts "Starting pledge server"

    pid = spawn(@process_name, :listen_loop, [[]])
    Process.register(pid, @process_name)
    pid
  end

  def create_pledge(name, amount) do
    call @process_name, {:create_pledge, name, amount}

    #receive do {:response, status} -> status end
  end

  def recent_pledges do
    call @process_name, :recent_pledges

    #receive do {:response, pledges} -> pledges end
  end

  def total_pledged do
    call @process_name, :total_pledged

    #receive do {:response, total} -> total end
  end

  def clear do
    cast @process_name, :clear
  end

  # Helper Functions
  def call(pid, message) do
    send pid, {self(), message}

    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, message
  end

  # Server

  def listen_loop(state \\ []) do
    IO.puts "\nWaiting for a message..."

    receive do

      {sender, message} when is_pid(sender) ->
        {response, new_state} = handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state)
      :clear ->
        new_state = []
        listen_loop(new_state)
      # {sender, {:create_pledge, name, amount}} ->
      #   {:ok, id} = send_pledge_to_service(name, amount)
      #   most_recent_pledges = Enum.take(state, 2)
      #   new_state = [ {name, amount} | most_recent_pledges ]
      #   send sender, {:response, id}
      #   listen_loop(new_state)
      # {sender, :recent_pledges} ->
      #   send sender, {:response, state}
      #   listen_loop(state)
      # {sender, :total_pledged} ->
      #   total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
      #   send sender, {:response, total}
      #   listen_loop(state)
      unexpected ->
        IO.puts "Unexpected message #{inspect unexpected}"
        listen_loop(state)
    end

  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [ {name, amount} | most_recent_pledges ]
    {id, new_state}
  end


  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end

# alias Servy.PledgeServer

# pid = PledgeServer.start()

# send pid, {:stop, "hammertime"}

# IO.inspect PledgeServer.create_pledge("larry", 10)
# IO.inspect PledgeServer.create_pledge("moe", 20)
# IO.inspect PledgeServer.create_pledge("curly", 30)
# IO.inspect PledgeServer.create_pledge("daisy", 40)
# IO.inspect PledgeServer.create_pledge("grace", 50)

# IO.inspect PledgeServer.recent_pledges()

# IO.inspect PledgeServer.total_pledged

# IO.inspect Process.info(pid, :messages)
