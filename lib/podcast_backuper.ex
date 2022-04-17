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

import SweetXml

url = "https://anchor.fm/s/248c0568/podcast/rss"
doc = PodcastBackuper.read_RSS(url)
title = doc.body |> xpath(~x"//channel/title/text()")
description = doc.body |> xpath(~x"//channel/description/text()")

IO.puts("RSS URL #{url}")
IO.puts("The title of this podcast is \"#{title} \"")
IO.puts("The description of this podcast is:")
IO.puts(description)

episode_titles =
  doc.body
  |> xpath(~x"//item/title/text()"sl)

IO.inspect(episode_titles)

links =
  doc.body
  |> xpath(~x"//item/link/text()"sl)

IO.inspect(links)

# audio_file_links =
#   doc.body
#   |> xpath(~x"//item/enclosure"el)
#   # |> Enum.map(fn x -> to_string(x) end)

# IO.inspect(audio_file_links)

# episodes =
#   doc.body
#   |> xpath(~x"//channel/item")

# IO.inspect(episodes)
