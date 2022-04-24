defmodule PodcastBackuper.Episode do
  defstruct [:title]

  def new(title) do
    %__MODULE__{title: title}
  end
end
