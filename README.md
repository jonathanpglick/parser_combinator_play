# Playing with parser combinators

Learning to use the [Combine](https://github.com/bitwalker/combine) parser
combinator library for Elixir by implementing a US phone number parser.

# Installation

`$ asdf install`

`$ mix deps.get`

# Running the parser

## IEx

`$ iex -S mix`

```
iex> PhoneNumber.parse("+1 (123) 456-7890")
%PhoneNumber{country_code: 1, area_code: 123, subscriber_number: "456-7890"}
```

`iex> PhoneNumber.test()`
