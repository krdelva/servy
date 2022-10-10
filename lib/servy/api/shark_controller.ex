defmodule Servy.Api.SharkController do

  def index(conv) do
    json =
      Servy.Wildthings.list_sharks()
      |> Poison.encode!

    %{ conv | status: 200, resp_content_type: "application/json", resp_body: json }
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end
end
