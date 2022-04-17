defmodule PodcastBackuper do
  @moduledoc """
  Documentation for `PodcastBackuper`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PodcastBackuper.hello()
      :world

  """
  def hello do
    :world
  end

  def read_RSS(filename) do
    HTTPoison.start()
    HTTPoison.get!(filename)
  end
end

result = PodcastBackuper.read_RSS("https://anchor.fm/s/248c0568/podcast/rss")

IO.puts(result.body)
