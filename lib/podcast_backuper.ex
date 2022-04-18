defmodule PodcastBackuper do
  @moduledoc """
  Documentation for `PodcastBackuper`.
  """

  import SweetXml

  def read_RSS(url) do
    HTTPoison.start()
    HTTPoison.get!(url, [], follow_redirect: true)
  end

  def process_url(url) do
    doc = read_RSS(url)
    process_body(doc.body)
  end

  def process_body(body) do
    episodes =
      body
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
        logo_link: ~x"//itunes:image/@href"s,
        duration: ~x"//itunes:duration/text()"s,
        season: ~x"//itunes:season/text()"s,
        number: ~x"//itunes:episode/text()"s,
        type: ~x"//itunes:episodeType/text()"s
      )

    [
      title: body |> xpath(~x"//channel/title/text()"),
      description: body |> xpath(~x"//channel/description/text()"),
      link: body |> xpath(~x"//channel/link/text()"),
      logo_link: body |> xpath(~x"//channel/image/url/text()"),
      episodes: episodes
    ]
  end

  # from https://elixirforum.com/t/how-to-download-big-files/9173/3
  def download!(file_url, filename) do
    file =
      if File.exists?(filename) do
        File.open!(filename, [:append])
      else
        File.touch!(filename)
        File.open!(filename, [:append])
      end

    %HTTPoison.AsyncResponse{id: ref} =
      HTTPoison.get!(file_url, %{}, follow_redirect: true, stream_to: self())

    append_loop(ref, file)
  end

  defp append_loop(ref, file) do
    receive do
      %HTTPoison.AsyncChunk{chunk: chunk, id: ^ref} ->
        IO.binwrite(file, chunk)
        append_loop(ref, file)

      %HTTPoison.AsyncEnd{id: ^ref} ->
        File.close(file)

      # need something to handle errors like request timeout and such
      # otherwise it will loop forever
      # don't know what httpoison returns in case of an error ...
      # you can inspect `_other` below to find out
      # and match on the error to exit the loop early
      _other ->
        append_loop(ref, file)
    end
  end
end

[
  # "http://feeds.libsyn.com/131788/rss",
  "https://anchor.fm/s/248c0568/podcast/rss",
  "https://anchor.fm/s/10f2ba74/podcast/rss"
]
|> Enum.map(fn rss ->
  data = PodcastBackuper.process_url(rss)
  IO.puts("RSS URL #{rss}")
  IO.puts("The title of this podcast is \"#{data[:title]}\"")
  IO.puts("The link of this podcast is #{data[:link]}")
end)

# As HTTPoison couldn't read  http://feeds.libsyn.com/131788/rss
# from https://viracasacas.libsyn.com/
# I saved the RSS as a file
# but it can with [follow_redirect: true]
# vira =
#   File.read!("./sample_rsss/viracasacas.rss")
#   |> PodcastBackuper.process_body()

# IO.puts("The title of this podcast is \"#{vira[:title]}\"")

# body = HTTPoison.get!("https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_episode/6031562/6031562-1591715087730-343b33e9ec68f.jpg", ["User-Agent": "Elixir"],
#  [recv_timeout: 300_000_00]).body
# File.write!("./oi.jpg", body)

# NAO FUNCIONA
# PodcastBackuper.download!(
#   "https://anchor.fm/s/248c0568/podcast/play/14948185/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2020-5-9%2F80802802-44100-2-38786b2278ffe.mp3",
#   "./ep0.mp3"
# )

# ESTE FUNCIONA
# PodcastBackuper.download!(
# "https://d3ctxlq1ktw2nl.cloudfront.net/production/2020-5-9/80802802-44100-2-38786b2278ffe.mp3",
# "./funfa.mp3"
# )

filename =
  "https://anchor.fm/s/248c0568/podcast/play/14948185/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2020-5-9%2F80802802-44100-2-38786b2278ffe.mp3"

%HTTPoison.Response{body: body} =
  HTTPoison.get!(
    filename,
    [],
    follow_redirect: true
  )

File.write!("./ep0.mp3", body)
