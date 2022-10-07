defmodule Servy.SharkController do

  alias Servy.Wildthings
  alias Servy.Shark

  defp shark_item(shark) do
    "<li>#{shark.name} - #{shark.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_sharks()
      |> Enum.filter(&Shark.is_tiger/1)
      |> Enum.sort(&Shark.order_ascending_by_name/2)
      |> Enum.map(&shark_item/1)
      |> Enum.join

    # TODO: Transofrm sharks to an HTML list.

    %{conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    shark = Wildthings.get_shark(id)

    %{conv | status: 200, resp_body: "<h1>Shark #{shark.id}: #{shark.name}</h1>"}
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Created a #{type} shark named #{name}!"}
  end

  def delete(conv, %{"id" => id}) do
    IO.puts "ID: " <> id

    IO.inspect conv

    sharks =
      Wildthings.list_sharks()
      |> Enum.filter(fn s -> Shark.match_shark?(id, s.id) end)
      |> Enum.join

    IO.inspect sharks
    #shark = Wildthings.get_shark(id)
    #%{conv | status: 200, resp_body: sharks}#"<h1>Shark #{shark.id}: #{shark.name}</h1>"}
  end

end
