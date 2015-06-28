defmodule ListParser do
  @spec parse(binary) :: list
  def parse(str) do
    {:ok, tokens, _} = str |> to_char_list |> :list_lexer.string
    {:ok, list}      = :list_parser.parse(tokens)
    list
  end
end
