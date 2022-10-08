defmodule Servy.SharkController do

  alias Servy.Wildthings
  alias Servy.Shark

  # @templates_path Path.expand("../../templates", __DIR__)

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
    items =
      Wildthings.list_sharks()
      |> Enum.filter(fn s -> Shark.match_shark?(id, s.id) end)
      |> Enum.map(&shark_item/1)
      |> Enum.join

    %{conv | status: 200, resp_body: items}
  end

end
