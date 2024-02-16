defmodule PhoneNumber do
  @moduledoc """
  Learning how to use the `Combine` parser combinator library

  Implements an extremely limited phone number parser. Very US-centric,
  probably doesn't handle international phone numbers very well at all.
  """
  use Combine

  defstruct [:country_code, :area_code, :subscriber_number]

  @type t :: %__MODULE__{}

  @spec parse(String.t()) :: t() | {:error, String.t()}
  def parse(input_string) do
    case Combine.parse(input_string, parser(), keyword: true) do
      result when is_list(result) ->
        struct(__MODULE__, result)

      error ->
        error
    end
  end

  def parser() do
    choice([
      phone_number(),
      phone_number_with_area_code(),
      phone_number_with_country_code_and_area_code()
    ])
  end

  def test() do
    IO.puts("")

    Enum.each(
      [
        "+1 (123) 456-7890",
        "+12 (123) 456-7890",
        "12 (123) 456-7890",
        "12 123 456 7890",
        "(123) 456-7890",
        "123.456.7890",
        "123-456-7890",
        "123/456/7890",
        "123 456 7890",
        "456-7890",
        "456.7890",
        "456-7890",
        "456/7890",
        "456 7890"
      ],
      &IO.inspect(parse(&1), label: String.pad_leading(&1, 20))
    )
  end

  # 394-1235, 391.1938, 918/8914
  defp phone_number(previous \\ nil) do
    previous
    |> pipe(
      [
        digits(3),
        map(separator(), fn _ -> "-" end),
        digits(4)
      ],
      &Enum.join/1
    )
    |> label("subscriber_number")
  end

  # (608) 347-1868, 608 347 1868, 608.347.1868
  defp phone_number_with_area_code() do
    area_code()
    |> ignore(separator())
    |> phone_number()
  end

  # +1 (608) 347-1868, 12 (608) 347-1868, 12 608 347 1868
  defp phone_number_with_country_code_and_area_code() do
    country_code()
    |> area_code()
    |> ignore(separator())
    |> phone_number()
  end

  # +1, +12, 1, 12
  defp country_code(previous \\ nil) do
    previous
    |> skip(char("+"))
    |> integer()
    |> skip(space())
    |> followed_by(area_code())
    |> label("country_code")
  end

  # (608), 608
  defp area_code(previous \\ nil) do
    previous
    |> choice([
      between(
        char("("),
        digits(3),
        char(")")
      ),
      digits(3)
    ])
    |> label("area_code")
  end

  defp digits(previous \\ nil, number) do
    previous
    |> times(digit(), number)
    |> map(&String.to_integer(Enum.join(&1)))
  end

  defp separator(previous \\ nil) do
    one_of(previous, char(), ["-", ".", "/", " "])
  end
end
