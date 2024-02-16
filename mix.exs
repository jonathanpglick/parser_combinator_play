defmodule ParserCombinatorPlay.MixProject do
  use Mix.Project

  def project do
    [
      app: :parser_combinator_play,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:combine, "~> 0.10"}
    ]
  end
end
