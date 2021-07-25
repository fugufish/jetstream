defmodule PullBasedConsumer.MixProject do
  use Mix.Project

  def project do
    [
      app: :pull_based_consumer,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {PullBasedConsumer.Application, []},
      extra_applications: [:logger, :jetstream]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jetstream, path: "../../"}
    ]
  end
end
