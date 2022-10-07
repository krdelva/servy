defmodule Servy.SharkController do

  alias Servy.Wildthings

  def index(conv) do
    sharks = Wildthings.list_sharks()

    response = "<ul>" <> Enum.map(sharks, &("<li>" <> &1.name <> "</li> ")) <> "</ul>"
    # TODO: Transofrm sharks to an HTML list.

    %{conv | status: 200, resp_body: response}
  end

  def show(conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Shark #{id}"}
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Created a #{type} shark named #{name}!"}
  end
end
