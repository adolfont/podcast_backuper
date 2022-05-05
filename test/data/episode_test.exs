defmodule PodcastBackuper.EpisodeTest do
  use ExUnit.Case

  alias PodcastBackuper.Episode

  test "Create a new episode entitled oi" do
    assert PodcastBackuper.Episode.new("oi") == %PodcastBackuper.Episode{title: "oi"}
  end

  test "Get the main information about an episode" do
    episode_xml = """
    <item>
    <title>#270 "É o parlamento, estúpido(!?)" - com Beatriz Falcão</title>
    <pubDate>Tue, 12 Apr 2022 09:34:45 +0000</pubDate>
    <guid isPermaLink="false"><![CDATA[e95c0a16-97ed-4922-8b66-5256e423c2b9]]></guid>
    <link><![CDATA[https://viracasacas.libsyn.com/270-o-parlamento-estpido-com-beatriz-falco]]></link>
    <itunes:image href="https://ssl-static.libsyn.com/p/assets/0/1/c/2/01c2540e1ffea5f1e5bbc093207a2619/88s-cgyL.jpg" />
    <description><![CDATA[<p>Saudações pessoas! É tempo de eleições (arrrgh!) e por isso contamos com a cientista política, lobista, podcaster e (ex)tudante de filosofia <em><strong><a href="https://twitter.com/bea_hawk" target="_blank" rel="noreferrer noopener">Beatriz Falcão</a></strong></em>, que comanda o podcast <strong>Patada de Pantufa</strong> - que lida com política e outras coisas com "p"! Falamos sobre as eleições vindouras, sobre a forma como precisamos pensar em eleger melhor os membros da Câmara Federal, sobre como as escolhas eleitorais ruins são uma tradição nacional, e, claro, sobre como é necessário que pensemos pragmática e estrategicamente essa que será talvez a eleição mais importante da história. Então, nada de purismos nem de nojinhos na hora de votar. Chapas perfeitas não existem. Já, chapas terríveis que precisam cair, bem: estão aí...!</p>]]></description>
    <content:encoded><![CDATA[<p>Saudações pessoas! É tempo de eleições (arrrgh!) e por isso contamos com a cientista política, lobista, podcaster e (ex)tudante de filosofia <em><a href="https://twitter.com/bea_hawk" target="_blank" rel="noreferrer noopener">Beatriz Falcão</a></em>, que comanda o podcast Patada de Pantufa - que lida com política e outras coisas com "p"! Falamos sobre as eleições vindouras, sobre a forma como precisamos pensar em eleger melhor os membros da Câmara Federal, sobre como as escolhas eleitorais ruins são uma tradição nacional, e, claro, sobre como é necessário que pensemos pragmática e estrategicamente essa que será talvez a eleição mais importante da história. Então, nada de purismos nem de nojinhos na hora de votar. Chapas perfeitas não existem. Já, chapas terríveis que precisam cair, bem: estão aí...!</p>]]></content:encoded>
    <enclosure length="77434050" type="audio/mpeg" url="https://traffic.libsyn.com/secure/viracasacas/VC270.mp3?dest-id=803878" />
    <itunes:duration>01:47:32</itunes:duration>
    <itunes:explicit>false</itunes:explicit>
    <itunes:keywords />
    <itunes:subtitle><![CDATA[Saudações pessoas! É tempo de eleições (arrrgh!) e por isso contamos com a cientista política, lobista, podcaster e (ex)tudante de filosofia , que comanda o podcast Patada de Pantufa - que lida com política e outras coisas com "p"! Falamos...]]></itunes:subtitle>
    <itunes:episodeType>full</itunes:episodeType>
    </item>
    """

    episode = Episode.process(episode_xml)

    assert episode[:title] == "#270 \"É o parlamento, estúpido(!?)\" - com Beatriz Falcão"
  end
end
