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
    %HTTPoison.Response{body: body} =
      HTTPoison.get!(
        file_url,
        [],
        follow_redirect: true
      )

    File.write!(filename, body)
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

url =
  "https://anchor.fm/s/248c0568/podcast/play/14948185/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2020-5-9%2F80802802-44100-2-38786b2278ffe.mp3"

PodcastBackuper.download!(
  url,
  "./ep0.mp3"
)
