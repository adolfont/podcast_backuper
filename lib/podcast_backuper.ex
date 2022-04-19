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
      title: body |> xpath(~x"//channel/title/text()"s),
      description: body |> xpath(~x"//channel/description/text()"s),
      link: body |> xpath(~x"//channel/link/text()"s),
      logo_link: body |> xpath(~x"//channel/image/url/text()"s),
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
