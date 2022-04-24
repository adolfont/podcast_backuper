defmodule PodcastBackuperTest do
  use ExUnit.Case

  setup_all do
    {:ok,
     professor_adolfo_neto:
       PodcastBackuper.process_url("https://anchor.fm/s/10f2ba74/podcast/rss"),
     fronteiras: PodcastBackuper.process_url("https://anchor.fm/s/248c0568/podcast/rss"),
     vira: PodcastBackuper.process_url("http://feeds.libsyn.com/131788/rss")}
  end

  describe "Testing the basic features of PodcastBackuper" do
    test "Get the correct title and link of the Professor Adolfo Neto podcast", state do
      data = state[:professor_adolfo_neto]
      assert data[:title] == "Professor Adolfo Neto"
      assert data[:link] == "https://adolfont.github.io/podcasts.html"
    end

    test "Get the correct title of the Fronteiras podcast", state do
      data = state[:fronteiras]
      assert data[:title] == "Fronteiras da Engenharia de Software"
      assert data[:link] == "https://fronteirases.github.io/"
    end

    test "Get the correct title of the Viracasacas Podcast", state do
      data = state[:vira]
      assert data[:title] == "Viracasacas Podcast"
      assert data[:link] == "http://viracasacas.com"
    end
  end

  # describe "Download the audio file of the latest episode of a podcast" do
  #   test "Downloads an audio file given a RSS", state do

  #     download_folder = "/home/ppgca/Downloads/podcast_backuper/ProfessorAdolfoNeto"
  #     data = state[:professor_adolfo_neto]

  #     assert data[:episodes] == 2

  #   end
  #   end

  describe "Downloading audio files" do
    test "Downloads an audio file" do
      url =
        "https://anchor.fm/s/248c0568/podcast/play/14948185/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2020-5-9%2F80802802-44100-2-38786b2278ffe.mp3"

      PodcastBackuper.download!(
        url,
        "./ep0.mp3"
      )

      assert File.exists?("./ep0.mp3")
      {:ok, %File.Stat{size: size}} = File.stat("./ep0.mp3")
      assert size == 12_787_331
    end
  end
end
