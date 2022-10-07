defmodule Servy.Shark do
    defstruct id: nil, name: "", type: "", sleeping: false

    def is_tiger(shark) do
      shark.type == "Tiger"
    end

    def order_ascending_by_name(shark1, shark2) do
      shark1.name <= shark2.name
    end

    def match_shark?(id1, id2) when is_integer(id1) do
      id1 != id2
    end

    def match_shark?(id1, id2) when is_binary(id1) do
      id1 |> String.to_integer() |> match_shark?(id2)
    end

end
