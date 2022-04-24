defmodule PodcastBackuper.EpisodeTest do
  use ExUnit.Case

  test "Create a new episode entitled oi" do
    assert PodcastBackuper.Episode.new("oi") == %PodcastBackuper.Episode{title: "oi"}
  end
end
