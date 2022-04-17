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

# "https://anchor.fm/s/248c0568/podcast/rss"
url = "https://anchor.fm/s/10f2ba74/podcast/rss"
doc = PodcastBackuper.read_RSS(url)
title = doc.body |> xpath(~x"//channel/title/text()")
_description = doc.body |> xpath(~x"//channel/description/text()")
link = doc.body |> xpath(~x"//channel/link/text()")
image_link = doc.body |> xpath(~x"//channel/image/url/text()")

IO.puts("RSS URL #{url}")
IO.puts("The title of this podcast is \"#{title} \"")
IO.puts("The link of this podcast is \"#{link} \"")
IO.puts("The link of the logo for this podcast is \"#{image_link} \"")
# IO.puts("The description of this podcast is:")
# IO.puts(description)

# episode_titles =
#   doc.body
#   |> xpath(~x"//item/title/text()"sl)

# IO.inspect(length(episode_titles))

# links =
#   doc.body
#   |> xpath(~x"//item/link/text()"sl)

# IO.inspect(length(links))

# audio_file_urls = doc.body |> xpath(~x"//item/enclosure/@url"sl)
# IO.inspect(length(audio_file_urls))

doc.body
|> xpath(
  ~x"//item"l,
  title: ~x"./title/text()"s,
  description: ~x"./description/text()"s,
  link: ~x"//link/text()"s,
  audio_file: [
    ~x"//enclosure"l,
    url: ~x"//@url"s,
    length: ~x"//@length"s,
    type: ~x"//@type"s
  ],
  pub_date: ~x"//pubDate/text()"s,
  episode_logo_link: ~x"//itunes:image/@href"s,
  duration: ~x"//itunes:duration/text()"s,
  season: ~x"//itunes:season/text()"s,
  episode_number: ~x"//itunes:episode/text()"s,
  episode_type: ~x"//itunes:episodeType/text()"s
)
|> IO.inspect()
