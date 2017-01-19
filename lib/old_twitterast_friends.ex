defmodule OldTwitterastFriends do
  alias OldTwitterastFriends.Retriever

  def main(args) do
    args |> parse_args |> process
  end

  def process([]) do
    IO.puts "No arguments given. Try with --name=your_username."
  end

  def process(options) do
    IO.puts(Retriever.csv(options[:name]))
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      switches: [name: :string]
    )

    options
  end
end
