defmodule Servy.SharkController do

  alias Servy.Wildthings

  def index(conv) do
    items =
      Wildthings.list_sharks()
      |> Enum.filter(fn s -> s.type == "Tiger" end)
      |> Enum.sort(fn s1, s2 -> s1.name <= s2.name end)
      |> Enum.map(fn s -> "<li>#{s.name} - #{s.type}</li>" end)
      |> Enum.join

    # TODO: Transofrm sharks to an HTML list.

    %{conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Shark #{id}"}
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Created a #{type} shark named #{name}!"}
  end
end
