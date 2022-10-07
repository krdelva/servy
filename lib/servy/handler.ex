defmodule Servy.Handler do

  @moduledoc """
    Handles HTTP requests.
  """

  alias Servy.Conv

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

  @pages_path Path.expand("../../pages", __DIR__)

  @doc " Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end


  # def route(conv), do: route(conv, conv.method, conv.path)

  def route(%Conv{ method: "GET", path: "/wildthings"} = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{ method: "GET", path: "/sharks" } = conv) do
    %{ conv | status: 200, resp_body: "Great White, Tiger, Hammer"}
  end

  def route(%Conv{ method: "GET", path: "/sharks/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Shark #{id}"}
  end

  def route(%Conv{ method: "DELETE", path: "/sharks/" <> _id } = conv) do
    %{ conv | status: 200, resp_body: "DELETE" }
  end

  # name=Cat&type=Calm
  def route(%Conv{ method: "POST", path: "/sharks"} = conv) do
    %{ conv | status: 201, resp_body: "Created a #{ conv.params["type"]} shark named #{conv.params["name"] }!" }
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    # File.read(__DIR__ <> "/../../pages/about.html")
    #file =
      @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{ method: "GET", path: "/sharks/new" } = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

    # case File.read(file) do
    #   {:ok, content} -> %{ conv | status: 200, resp_body: content}
    #   {:error, :enoent} -> %{ conv | status: 404, resp_body: "File not found!!!"}
    #   {:error, reason} -> %{ conv | status: 500, resp_body: "File error: #{reason}"}
    # end

  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end




  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end



end


request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /sharks HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /sharks1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request = """
GET /sharks/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)


request = """
POST /sharks HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlenconded
Content-Length: 21

name=Cat&type=Calm
"""

IO.puts Servy.Handler.handle(request)
