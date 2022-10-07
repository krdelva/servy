defmodule Servy.Wildthings do
  alias Servy.Shark

  def list_sharks do
    [
      %Shark{id: 1, name: "Bob", type: "Great White"},
      %Shark{id: 2, name: "Paul", type: "Tiger"},
      %Shark{id: 3, name: "Sheila", type: "Cat", sleeping: true},
      %Shark{id: 4, name: "Angela", type: "Tiger"},
      %Shark{id: 5, name: "Robin", type: "Great White", sleeping: true},
      %Shark{id: 6, name: "Cookie", type: "Cat"},
      %Shark{id: 7, name: "Erik", type: "Tiger", sleeping: true},
    ]
  end

  def get_shark(id) when is_integer(id) do
    Enum.find(list_sharks(), &(&1.id == id))
  end

  def get_shark(id) when is_binary(id) do
    id |> String.to_integer() |> get_shark
  end

  def match_shark?(id1, id2) when is_integer(id1) do
    id1 != id2
  end

  def match_shark?(id1, id2) when is_binary(id1) do
    id1 |> String.to_integer() |> match_shark?(id2)
  end

end
