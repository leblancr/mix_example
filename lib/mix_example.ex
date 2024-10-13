defmodule MixExample do
  @moduledoc """
  Documentation for `MixExample`.
    An example Mix project
  """

  require Integer

  @doc """
  ## MixExamples

      iex> MixExample.hello()
      :world

  """

  # Define the sigil directly in this module
  # Default behavior: convert string to uppercase when no options are provided
  def sigil_p(string, []) do
    IO.puts "no Flag received"
    String.upcase(string)
  end

  # Handle cases where there's one option
  def sigil_p(string, [flag]) do
    IO.inspect(flag, label: "Flag received")
    case flag do
      :lowercase -> String.downcase(string)
      :uppercase -> String.upcase(string)
      _ -> string  # Default behavior if the flag is not recognized
    end
  end

  def puts(message), do: IO.puts(message)

  def sigils do
    puts ~c/2 + 7 = #{2 + 7}/
    puts ~C/2 + 7 = #{2 + 7}/

    # =~ is not used for assignment; rather, it's used to perform a check.
    re = ~r/elixir/
    string1 = "Elixir"
    string2 = "elixir"
    result1 = string1 =~ re
    result2 = string2 =~ re

    # Print the statement and the result
    puts("#{string1} =~ #{inspect(re)}: #{result1}")
    puts("#{string2} =~ #{inspect(re)}: #{result2}")

    re = ~r/elixir/i
    result1 = string1 =~ re
    result2 = string2 =~ re

    puts("#{string1} =~ #{inspect(re)}: #{result1}")
    puts("#{string2} =~ #{inspect(re)}: #{result2}")

    string = "100_000_000"
    puts "string: " <> string
    result = Regex.split(~r/_/, string)  |> Enum.join(", ")
    puts "Regex.split(~r/_/, string): " <> result

    puts ~p/elixir school, [:lowercase]/
    puts "Default sigil output: #{~p(elixir school)}"  # Should output "ELIXIR SCHOOL"
    puts "Lowercase sigil output: #{~p(elixir school, [:lowercase, :test])}"  # Should output "elixir school"
  end

  def comprehensions do
    # *** Comprehensions ***
    res = for x <- [1, 2, 3, 4, 5], do: x*x
    puts("Squared values: #{inspect(res)}")

    # Keyword Lists
    res = for {_key, val} <- [one: 1, two: 2, three: 3], do: val
    puts("Keyword List values: #{inspect(res)}")

    # Maps
    res = for {k, v} <- %{"a" => "A", "b" => "B"}, do: {k, v}
    puts("Maps key, values: #{inspect(res)}")

    # Binaries
    res = for <<c <- "hello">>, do: <<c>>
    puts("Binaries: #{inspect(res)}")

    # just keys you want
    res = for {:ok, val} <- [ok: "Hello", error: "Unknown", ok: "World"], do: val
    puts("ok: only: #{inspect(res)}")

    # nested
    list = [1, 2, 3, 4]
    res = for n <- list, times <- 1..n do
      String.duplicate("*", times)
    end
    puts("output: #{inspect(res)}")

    # nested
    res = for n <- list, times <- 1..n, do: puts "#{n} - #{times}"
    puts("nested: #{inspect(res)}")
  end

  def filters do
    # *** Filters ***
    res = for x <- 1..10, Integer.is_even(x), do: x
    puts("evens: #{inspect(res)}")

    # multiple filters
    res = for x <- 1..100,
              Integer.is_even(x),
              rem(x, 3) == 0,
              rem(x, 5) ==0, do: x
    puts("multiple filters: #{inspect(res)}")
  end

  def using_into do
    # *** Using :into ***
    res = for {k, v} <- [one: 1, two: 2, three: 3], into: %{}, do: {k, v}
    puts("Using :into: #{inspect(res)}")

    # use list comprehensions and :into to create strings:
    res = for c <- [72, 101, 108, 108, 111], into: "", do: <<c>>
    puts("Using comprehensions :into: strings:#{inspect(res)}")
  end

  def strings do
    # Strings
    string = <<104,101,108,108,111>>
    puts "string = <<104,101,108,108,111>>: #{string}"

    string = string <> <<0>>
    IO.write("string = string <> <<0>>: ")
    IO.inspect(string)

    # Charlists
    IO.write("'hełło': ")
    IO.inspect('hełło')

    string = ~c/"hełło" <> <<0>>: /
    IO.write(string)
    string = "hełło" <> <<0>>
    IO.inspect(string)

    puts "?Z: #{?Z}"
  end

  def main do
    sigils()
    comprehensions()
    filters()
    using_into()
    strings()
  end
end
