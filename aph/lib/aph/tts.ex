defmodule Aph.TTS do
  def synthesize(name, text, pitch, speed) do
    File.mkdir_p!("gentts/#{name}")

    if Application.get_env(:aph, :tts) == "google" do
      api_key = Application.get_env(:aph, :google_key)

      body =
        Jason.encode!(%{
          input: %{text: text},
          voice: %{languageCode: "en-US", name: "en-US-Standard-B"},
          audioConfig: %{audioEncoding: "OGG_OPUS", pitch: pitch || 0, speakingRate: speed || 1.0}
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
           :ok <- File.write("gentts/#{name}/temp.ogg", content),
           :ok <- align(name, text) do
        :ok
      else
        {:error, err} -> {:tts_error, err}
      end
    else
      scale_pitch = (pitch + 20) / 40 * 99
      scale_speed = floor((speed - 0.25) / 3.75 * 370.0 + 80.0)

      with {_, 0} <-
             System.cmd("espeak", [
               "-p",
               to_string(scale_pitch),
               "-s",
               to_string(scale_speed),
               "-w",
               "gentts/#{name}/temp.wav",
               text
             ]),
           {_, 0} <-
             System.cmd("ffmpeg", [
               "-i",
               "gentts/#{name}/temp.wav",
               "-c:a",
               "libopus",
               "-b:a",
               "96K",
               "gentts/#{name}/temp.ogg"
             ]),
           :ok <- align(name, text) do
        :ok
      else
        {_error, 1} -> {:tts_error, name}
      end
    end
  end

  def clean(name) do
    with :ok <- File.cp("gentts/#{name}/out.json", "priv/static/st#{name}.json"),
         :ok <- File.cp("gentts/#{name}/temp.ogg", "priv/static/st#{name}.ogg"),
         {:ok, _} <- File.rm_rf("gentts/#{name}") do
      :ok
    else
      e -> {:tts_error, name}
    end
  end

  defp align(name, text) do
    with :ok <-
           File.write("gentts/#{name}/temp.txt", text |> String.split(" ") |> Enum.join("\n")),
         {_, 0} <-
           System.cmd("python3", [
             "-m",
             "aeneas.tools.execute_task",
             "gentts/#{name}/temp.ogg",
             "gentts/#{name}/temp.txt",
             "task_language=eng|os_task_file_format=json|is_text_type=plain",
             "gentts/#{name}/out.json"
           ]) do
      :ok
    else
      {:error, err} -> {:error, err}
      {err, 1} -> {:error, err}
    end
  end
end
