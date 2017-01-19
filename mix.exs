defmodule OldTwitterastFriends.Mixfile do
  use Mix.Project

  def project do
    [app: :old_twitterast_friends,
     version: "0.1.0",
     elixir: "~> 1.4",
     escript: [main_module: OldTwitterastFriends],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :timex, :tzdata]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.7"},
      {:timex, "~> 3.0"},
      {:tzdata, "~> 0.1.8"},
      {:csv, "~> 1.4.2"}
    ]
  end
end
