defmodule PodcastBackuper.Episode do
  defstruct [:title]

  def new(title) do
    %__MODULE__{title: title}
  end

  def process(_string_xml) do
    %__MODULE__{title: "oi"}
  end
end
