defmodule Servy.SharkController do

  alias Servy.Wildthings
  alias Servy.Shark

  @templates_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  defp shark_item(shark) do
    "<li>#{shark.name} - #{shark.type}</li>"
  end

  def index(conv) do
    # items =
    #   Wildthings.list_sharks()
    #   |> Enum.filter(&Shark.is_tiger/1)
    #   |> Enum.sort(&Shark.order_ascending_by_name/2)
    #   |> Enum.map(&shark_item/1)
    #   |> Enum.join
    sharks =
      Wildthings.list_sharks()
      |> Enum.sort(&Shark.order_ascending_by_name/2)

      render(conv, "index.eex", sharks: sharks)

    # content =
    #   @templates_path
    #   |> Path.join("index.eex")
    #   |> EEx.eval_file(sharks: sharks)

    # %{conv | status: 200, resp_body: content}#"<ul>#{items}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    shark = Wildthings.get_shark(id)


    render(conv, "show.eex", shark: shark)
    # content =
    #   @templates_path
    #   |> Path.join("show.eex")
    #   |> EEx.eval_file(shark: shark)

    # %{conv | status: 200, resp_body: content}
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
