defmodule ListParserTest do
  use ExUnit.Case

  test "Lexer on empty list" do
     {:ok, tokens, _} = :list_lexer.string('[]')
     assert tokens == ["[": 1, "]": 1]
  end

  test "Lexer on list with one element" do
     {:ok, tokens, _} = :list_lexer.string('[1]')
     assert tokens == ["[": 1, int: 1, "]": 1]
  end

  test "Lexer on list with two elements" do
     {:ok, tokens, _} = :list_lexer.string('[1, :foo]')
     assert tokens == ["[": 1, int: 1, ",": 1, atom: :foo, "]": 1]
  end

  test "Lexer with a nested list" do
     {:ok, tokens, _} = :list_lexer.string('[1, [:foo]]')
     assert tokens == ["[": 1, int: 1, ",": 1, "[": 1, atom: :foo, "]": 1, "]": 1]
  end

  test "Parser" do
    tokens = [{:"[", 1}, {:atom, 1, :foo}, {:"]", 1}]
    assert :list_parser.parse(tokens) == {:ok, [:foo]}
  end

  # Examples from http://andrealeopardi.com/posts/tokenizing-and-parsing-in-elixir-using-leex-and-yecc/ :
  
  test "Read an Elixir list expressed as a string and convert it back to an Elixir string" do
    source = "[1, 2, [:foo, [:bar]]]"
    assert ListParser.parse(source) == [1, 2, [:foo, [:bar]]]
  end

  test "Feed the output of the lexer directly into the parser" do
    source = "[:foo, [1], [:bar, [2, 3]]]"
    {:ok, tokens, _} = source |> String.to_char_list |> :list_lexer.string
    assert :list_parser.parse(tokens) == {:ok, [:foo, [1], [:bar, [2, 3]]]}
  end

end
