defmodule Servy.Handler do

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method,
       path: path,
       resp_body: "",
       status: nil
     }
  end

  def rewrite_path(%{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  # def route(conv), do: route(conv, conv.method, conv.path)

  def route(%{ method: "GET", path: "/wildthings"} = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{ method: "GET", path: "/sharks" } = conv) do
    %{ conv | status: 200, resp_body: "Great White, Tiger, Hammer"}
  end

  def route(%{ method: "GET", path: "/sharks/" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Shark #{id}"}
  end

  def route(%{ method: "DELETE", path: "/sharks/" <> _id} = conv) do
    %{ conv | status: 200, resp_body: "DELETE" }
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!"}
  end

  def track(%{status: 400, path: path} = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end


request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request)

request2 = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

IO.puts Servy.Handler.handle(request2)


"""
def rewrite(%{ path: "/bears?id=" <> id } = conv) do
  %{ conv | path: "/bears\#{id} }
end

def emojify(%{ status: 200 } = conv) do
  %{ conv | resp_body: "emoji" <> conv.resp_body <> "emoji"}
end

def emojify(conv), do: conv
"""
