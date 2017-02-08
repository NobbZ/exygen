defmodule Exygen.Mixfile do
  use Mix.Project

  def project do
    [app: :exygen,
     version: "0.0.1-dev",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  def aliases do
    [c: ["deps.get", "deps.compile", "compile", "docs"],
     r: ["clean", "c"],
     lint: ["dialyzer", "inch", "credo list"]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    System.version()
    |> Version.match?(">= 1.4.0")
    |> if do
      [extra_applications: [:logger]]
    else
      [applications: [:logger]]
    end
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev},
      {:earmark, "~> 1.1", only: :dev},
      {:credo, "~> 0.6", only: :dev},
      {:inch_ex, "~> 0.5", only: :dev},
      {:dialyxir, "~> 0.4", only: :dev},
    ]
  end
end
