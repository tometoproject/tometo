defmodule Aph.TTS do
  @moduledoc """
  TTS generation and alignment functions.

  This module takes care of everything related to TTS (text-to-speech)
  generation and parsing/aligning. It's also the module that introduces the most
  side effects in the entire app, because it has to shell out to various programs
  and make HTTP calls.
  """

  # This is the language map for the Google TTS API
  @g_lang_map %{
    ar: "ar-XA",
    nl: "nl-NL",
    en: "en-US",
    fr: "fr-FR",
    de: "de-DE",
    hi: "hi-IN",
    id: "id-ID",
    it: "it-IT",
    ja: "ja-JP",
    ko: "ko-KR",
    zh: "cmn-CN",
    nb: "nb-NO",
    pl: "pl-PL",
    pt: "pt-PT",
    ru: "ru-RU",
    tr: "tr-TR",
    vi: "vi-VN"
  }

  # This is the language map for `aeneas`
  @a_lang_map %{
    ar: :ara,
    nl: :nld,
    en: :eng,
    fr: :fra,
    de: :deu,
    hi: :hin,
    id: :ind,
    it: :ita,
    ja: :jpn,
    ko: :kor,
    zh: :cmn,
    nb: :nor,
    pl: :pol,
    pt: :por,
    ru: :rus,
    tr: :tur,
    vi: :vie
  }

  @doc """
  Generates a TTS message.

  Takes a database entity, a file prefix and a Aph.Main.Avatar.

  The database entity can be generic, but must at least have an ID and a `content`
  field. The file prefix is used to prevent filename collisions, since IDs can
  be the same across multiple database tables.

  First creates a temporary directory under `gentts/`, then depending on the
  TTS synthesis configuration option pulls the audio from somewhere and saves it
  in the temporary directory. Then calls TTS.align/3.
  """
  def synthesize(entity, prefix, av) do
    File.mkdir_p!("gentts/#{prefix}-#{entity.id}")

    if Application.get_env(:aph, :tts) == "google" do
      synthesize_google(entity, prefix, av)
    else
      synthesize_espeak(entity, prefix, av)
    end
  end

  @doc """
  Synthesize TTS with Google Text-to-Speech API.
  """
  defp synthesize_google(entity, prefix, av) do
    api_key = Application.get_env(:aph, :google_key)
    lang = @g_lang_map[String.to_atom(av.language)]

    gender_num =
      cond do
        # en-US has no Standard-A voice for some reason
        lang == "en-US" and av.gender == "FEMALE" -> "C"
        lang == "en-US" and av.gender == "MALE" -> "B"
        av.gender == "FEMALE" -> "A"
        true -> "B"
      end

    body =
      Jason.encode!(%{
        input: %{text: entity.content},
        voice: %{languageCode: lang, name: "#{lang}-Standard-#{gender_num}"},
        audioConfig: %{
          audioEncoding: "OGG_OPUS",
          pitch: av.pitch || 0,
          speakingRate: av.speed || 1.0
        }
      })

    headers = [{"content-type", "application/json"}]

    with {:ok, res} <-
           HTTPoison.post(
             "https://texttospeech.googleapis.com/v1/text:synthesize?key=#{api_key}",
             body,
             headers
           ),
         {:ok, json} <- Jason.decode(res.body),
         {:ok, content} <- Base.decode64(json["audioContent"]),
         :ok <- File.write("gentts/#{prefix}-#{entity.id}/temp.ogg", content),
         :ok <- align(entity.id, entity.content, prefix, av.language) do
      :ok
    else
      {:error, err} -> {:tts_error, err}
    end
  end

  @doc """
  Synthesizes TTS using espeak.
  """
  defp synthesize_espeak(entity, prefix, av) do
    # Since espeak doesn't accept the same values that the Google TTS api does,
    # we have to convert them from one scale to another.
    scale_pitch = (av.pitch + 20) / 40 * 99
    scale_speed = floor((av.speed - 0.25) / 3.75 * 370.0 + 80.0)

    with {_, 0} <-
           System.cmd("espeak", [
             "-p",
             to_string(scale_pitch),
             "-s",
             to_string(scale_speed),
             "-w",
             "gentts/#{prefix}-#{entity.id}/temp.wav",
             entity.content
           ]),
         {_, 0} <-
           System.cmd("ffmpeg", [
             "-i",
             "gentts/#{prefix}-#{entity.id}/temp.wav",
             "-c:a",
             "libopus",
             "-b:a",
             "96K",
             "gentts/#{prefix}-#{entity.id}/temp.ogg"
           ]),
         :ok <- align(entity.id, entity.content, prefix, av.language) do
      :ok
    else
      {_error, 1} -> {:tts_error, "espeak failed to create audio!"}
    end
  end

  @doc """
  Removes temporary directory and moves files to a permanent location.

  Takes the name of the temporary directory.
  """
  def clean(name) do
    with :ok <- File.cp("gentts/#{name}/out.json", "priv/static/#{name}.json"),
         :ok <- File.cp("gentts/#{name}/temp.ogg", "priv/static/#{name}.ogg"),
         {:ok, _} <- File.rm_rf("gentts/#{name}") do
      :ok
    else
      e -> {:tts_error, e}
    end
  end

  @doc """
  Forcibly aligns an existing TTS message.

  Takes the name/ID, the TTS text, and the language.

  This shells out to `aeneas` and obtains a JSON file that contains timestamps
  of when in the audio file which word is said.
  """
  def align(name, text, prefix, lang) do
    lang = @a_lang_map[String.to_atom(lang)]

    with :ok <-
           File.write(
             "gentts/#{prefix}-#{name}/temp.txt",
             text |> String.split(" ") |> Enum.join("\n")
           ),
         {_, 0} <-
           System.cmd("python3", [
             "-m",
             "aeneas.tools.execute_task",
             "gentts/#{prefix}-#{name}/temp.ogg",
             "gentts/#{prefix}-#{name}/temp.txt",
             "task_language=#{Atom.to_string(lang)}|os_task_file_format=json|is_text_type=plain",
             "gentts/#{prefix}-#{name}/out.json"
           ]) do
      :ok
    else
      {:error, err} -> {:error, err}
      {err, 1} -> {:error, err}
    end
  end
end
