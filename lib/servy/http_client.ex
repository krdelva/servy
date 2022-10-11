defmodule Servy.HttpClient do
#   def send_request(request) do
#     some_host_in_net = 'localhost'  # to make it runnable on one machine
#     {:ok, socket} =
#       :gen_tcp.connect(some_host_in_net, 7070, [:binary, packet: :raw, active: false])
#     :ok = :gen_tcp.send(socket, request)
#     #{:ok, response} = :gen_tcp.recv(socket, 0)
#     case :gen_tcp.recv(socket, 0) do
#       {:ok, response} ->
#         :ok = :gen_tcp.close(socket)
#         response
#       {:error, response} ->
#         :ok = :gen_tcp.close(socket)
#         response
#     end
#     #:ok = :gen_tcp.close(socket)
#     #response
#   end

  # parent = self()

  # power_nap = fn ->
  #   time = :rand.uniform(10_000)
  #   :timer.sleep(time)
  #   time
  # end

  # spawn(fn ->
  #   IO.puts "SPAWNED #{inspect self()}"
  #   send(parent, {:slept, power_nap.()})
  # end)

  # Process.info(parent, :messages)
  # receive do
  #   {:slept, time} -> IO.puts "Slept for #{time} ms"
  #     # code
  # end


 #{:ok, response } =  HTTPoison.get "https://jsonplaceholder.typicode.com/users/1"
  #response.status_code

  # case HTTPoison.get("https://jsonplaceholder.typicode.com/users/1") do
  #   { :ok, response } -> response
  #   {_ } -> IO.puts "ERROR"
  # end

  # def get_response({ :ok, json } = response) do
  #   IO.inspect json
  # end



  def query do
    "1"
    |> api_url
    |> HTTPoison.get
    |> handle_response
  end

  defp api_url(id) do
    "https://jsonplaceholder.typicode.com/users/#{URI.encode(id)}"
  end

  defp handle_response({ :ok, %{ status_code: 200, body: body}}) do
    city =
      Poison.Parser.parse!(body, %{})
      |> get_in(["address", "city"])
  end

  defp handle_response({ :ok, %{ status_code: status_code }}) do
    status_code
  end

end

# request = """
# GET /bears HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# \r
# """

# spawn(fn -> Servy.HttpServer.start(8000) end)
# |> Process.info(:memory)

# $response = Servy.HttpClient.send_request(request)
# IO.puts response
