defmodule Anagram do
  def anagrams?(a, b) when is_binary(a) and is_binary(b) do
    sort_string(a) == sort_string(b)
  end

  def sort_string(string) do
    string
    |> String.downcase()
    |> String.graphemes()
    |> Enum.sort()
  end
end

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
    puts "\n*** Sigils ***"
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
    puts "\n*** Comprehensions *** "
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
    puts "\n*** Filters ***"
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
    puts "\n*** Using :into ***"
    res = for {k, v} <- [one: 1, two: 2, three: 3], into: %{}, do: {k, v}
    puts("Using :into: #{inspect(res)}")

    # use list comprehensions and :into to create strings:
    res = for c <- [72, 101, 108, 108, 111], into: "", do: <<c>>
    puts("Using comprehensions :into: strings:#{inspect(res)}")
  end

  def strings do
    puts "\n***** Strings *****"
    # Using << >> syntax we are saying to the compiler that
    # the elements inside those symbols are bytes
    string = <<104, 101, 108, 108, 111>> # bytes
    puts "string = <<104, 101, 108, 108, 111>>: #{string}" # hello

    # concatenating the string with the byte 0, IEx displays the string
    # as a binary because it is not a valid string anymore
    string = string <> <<0>>
    IO.write("string = string <> <<0>>: ")
    IO.inspect(string) # <<104, 101, 108, 108, 111, 0>>

    # Elixir strings are enclosed with double quotes,
    # while char lists are enclosed with single quotes.
    # Each value in a charlist is the Unicode code point of a character
    # whereas in a binary, the codepoints are encoded as UTF-8
    puts "\n*** Charlists ***"
    IO.write("'hełło': ")
    IO.inspect(~c/hełło/) # list of unicode, [104, 101, 322, 322, 111]

    string = ~c/"hełło" <> <<0>>: /
    IO.write(string)
    string = "hełło" <> <<0>>
    IO.inspect(string) # UTF8, <<104, 101, 197, 130, 197, 130, 111, 0>>

    # 322 is the Unicode codepoint for ł but it is encoded in UTF-8 as the two bytes 197, 130
    puts "?Z: #{?Z}" # get a character’s code point by using ?
  end

  def graphemes_and_codepoints do
    puts "\n*** graphemes_and_codepoints ***"
    # Graphemes consist of multiple codepoints that are rendered as a single character.
    string = ~c/u0061\\u0301/
    puts "#{string}: \u0061\u0301"

    string = "\u0061\u0301"
    res = String.codepoints string
    puts "String.codepoints string: #{inspect(res)}"

    res = String.graphemes string
    puts "String.graphemes string: #{inspect(res)}"
  end

  def string_functions do
    puts "\n*** string_functions ***"
    puts "length/1"
    puts "String.length \"Hello\": #{String.length "Hello"}"

    puts "replace/3"
    puts "String.replace(\"Hello\", \"e\", \"a\"): #{String.replace("Hello", "e", "a")}"

    puts "duplicate/2"
    puts "String.duplicate(\"Oh my \", 3): #{String.duplicate("Oh my ", 3)}"

    puts "split/2"
    puts "String.split(\"Hello World\", \" \"): #{inspect(String.split("Hello World", " "))}"

    # the question mark (?) is used as a convention to indicate that a function returns a boolean value
    puts "Anagram.anagrams?(\"Hello\", \"ohell\"): #{Anagram.anagrams?("Hello", "ohell")}"
    puts "Anagram.anagrams?(\"María\", \"íMara\"): #{Anagram.anagrams?("María", "íMara")}"
  end

  def date_and_time do
    puts "\n***** Date and Time *****"
    puts "\n*** Time ***"
    puts "Time.utc_now: #{inspect(Time.utc_now)}"
    t = Time.utc_now
    puts "t.hour: #{t.hour}"
    puts "t.minute: #{t.minute}"
    puts "t.minute: #{t.minute}"

    puts "\n*** Date ***"
    puts "Date.utc_today: #{inspect(Date.utc_today)}"
    {:ok, date} = Date.new(2020, 12, 12)
    puts "Date.day_of_week date: #{Date.day_of_week date}"
    puts "Date.leap_year? date: #{Date.leap_year? date}"

    puts "\n*** NaiveDateTime ***"
    # ~N[2016-05-24 13:26:08.003] ~N is naive date time
    puts "NaiveDateTime.utc_now: #{inspect(NaiveDateTime.utc_now)}"
    puts "NaiveDateTime.add(NaiveDateTime.utc_now, 30): #{NaiveDateTime.add(NaiveDateTime.utc_now, 30)}"

    puts "\n*** DateTime ***"
    naive_datetime = NaiveDateTime.utc_now()
    timezone = "Etc/UTC"

    case DateTime.from_naive(naive_datetime, timezone) do
      {:ok, datetime} ->
        puts "DateTime.from_naive(#{naive_datetime}, \"#{timezone}\"): #{datetime}"
      {:error, reason} ->
        puts "Error converting naive datetime: #{reason}"
    end

    paris_datetime = DateTime.from_naive!(NaiveDateTime.utc_now, "Europe/Paris")
    puts "paris_datetime: #{paris_datetime}"

    {:ok, ny_datetime} = DateTime.shift_zone(paris_datetime, "America/New_York")
    puts "ny_datetime: #{ny_datetime}"
  end

  def main do
    sigils()
    comprehensions()
    filters()
    using_into()
    strings()
    graphemes_and_codepoints()
    string_functions()
    date_and_time()

  end
end
