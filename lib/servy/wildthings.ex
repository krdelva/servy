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

end
