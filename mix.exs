defmodule TurbolinksPlug.Mixfile do
  use Mix.Project

  def project do
    [
      app: :turbolinks_plug,
      version: "1.0.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      docs: [
        extras: ~W(README.md)
      ]
    ]
  end

  def application do
    [applications: [:logger, :plug]]
  end

  defp deps do
    [
      {:plug, "~> 1.5"},
      {:ex_doc, "~> 0.18"}
    ]
  end

   defp description do
    """
    An elixir plug that adds headers on redirects to hint turbolinks correct URL
    """
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE),
      maintainers: ["Boris Mikhaylov"],
      licenses: ["MIT"],
      links: %{
        "Github" => "http://github.com/kagux/turbolinks_plug",
        "Docs"   => "http://hexdocs.pm/turbolinks_plug",
      }
    ]
  end
end
