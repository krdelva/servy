defmodule Servy.HttpClient do
  def send_request(request) do
    some_host_in_net = 'localhost'  # to make it runnable on one machine
    {:ok, socket} =
      :gen_tcp.connect(some_host_in_net, 7070, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(socket, request)
    #{:ok, response} = :gen_tcp.recv(socket, 0)
    case :gen_tcp.recv(socket, 0) do
      {:ok, response} ->
        :ok = :gen_tcp.close(socket)
        response
      {:error, response} ->
        :ok = :gen_tcp.close(socket)
        response
    end
    #:ok = :gen_tcp.close(socket)
    #response
  end
end

request = """
GET /bears HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

spawn(fn -> Servy.HttpServer.start(7070) end)
|> Process.info(:memory)

response = Servy.HttpClient.send_request(request)
IO.puts response
