defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]


  test "POST /api/bears" do
    request = """
    POST /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Breezly", "type": "Polar"}
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 35\r
    \r
    Created a Polar bear named Breezly!
    """
  end


  test "GET /api/sharks" do
    request = """
    GET /api/sharks HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 605\r
    \r
     [{"id":1,"name":"Bob","type":"Great White","sleeping":false},
      {"id":2,"name":"Paul","type":"Tiger","sleeping":false},
      {"id":3,"name":"Sheila","type":"Cat","sleeping":true},
      {"id":4,"name":"Angela","type":"Tiger","sleeping":false},
      {"id":5,"name":"Robin","type":"Great White","sleeping":true},
      {"id":6,"name":"Cookie","type":"Cat","sleeping":false},
      {"id":7,"name":"Erik","type":"Tiger","sleeping":true}]
    """

    assert String.trim(response) == String.trim(expected_response)
    #assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  # [{"type":"Brown","name":"Teddy","id":1,"hibernating":true},
  # {"type":"Black","name":"Smokey","id":2,"hibernating":false},
  # {"type":"Brown","name":"Paddington","id":3,"hibernating":false},
  # {"type":"Grizzly","name":"Scarface","id":4,"hibernating":true},
  # {"type":"Polar","name":"Snow","id":5,"hibernating":false},
  # {"type":"Grizzly","name":"Brutus","id":6,"hibernating":false},
  # {"type":"Black","name":"Rosie","id":7,"hibernating":true},
  # {"type":"Panda","name":"Roscoe","id":8,"hibernating":false},
  # {"type":"Polar","name":"Iceman","id":9,"hibernating":true},
  # {"type":"Grizzly","name":"Kenai","id":10,"hibernating":false}]
end
