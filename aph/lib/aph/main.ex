defmodule Aph.Main do
  import Ecto.Query, warn: false
  alias Aph.Repo
  alias Aph.TTS

  alias Aph.Main.Avatar

  def list_avatars do
    Repo.all(Avatar)
  end

  def get_avatar(id), do: Repo.get!(Avatar, id)

  def create_avatar(attrs \\ %{}, pic1, pic2) do
    with {:ok, avatar} <- %Avatar{} |> Avatar.changeset(attrs) |> Repo.insert(),
         :ok <- File.cp(pic1.path, elem(avatar_picture_path(avatar.id), 0)),
         :ok <- File.cp(pic2.path, elem(avatar_picture_path(avatar.id), 1)) do
      {:ok, avatar}
    else
      {:error, _reason} = error -> error
    end
  end

  def update_avatar(%Avatar{} = avatar, attrs \\ %{}, pic1, pic2) do
    with {:ok, avatar} <- avatar |> Avatar.changeset(attrs) |> Repo.update() do
      if !is_bitstring(pic1) do
        :ok = File.cp(pic1.path, elem(avatar_picture_path(avatar.id), 0))
      end

      if !is_bitstring(pic2) do
        :ok = File.cp(pic2.path, elem(avatar_picture_path(avatar.id), 1))
      end

      {:ok, avatar}
    else
      {:error, _reason} = error -> error
    end
  end

  def delete_avatar(%Avatar{} = avatar) do
    Repo.delete(avatar)
  end

  def change_avatar(%Avatar{} = avatar) do
    Avatar.changeset(avatar, %{})
  end

  def avatar_picture_path(id) do
    pic1 = ["priv/static", "av#{id}-1.png"] |> Path.join()
    pic2 = ["priv/static", "av#{id}-2.png"] |> Path.join()
    {pic1, pic2}
  end

  alias Aph.Main.Status

  def list_statuses do
    Repo.all(Status)
  end

  def get_status(id) do
    s = Repo.one(from(s in Status, where: s.id == ^id, preload: :avatar))
    Map.merge(s, format_status_for_display(s))
  end

  def get_status_comments(id) do
    query =
      from s in Status,
        where: s.related_status_id == ^id,
        select: s,
        preload: :avatar

    statuses = Repo.all(query)
    Enum.map(statuses, fn s -> Map.merge(s, format_status_for_display(s)) end)
  end

  defp format_status_for_display(%Status{} = status) do
    hostname = Application.get_env(:aph, :hostname)
    avatar = status.avatar
    audio_path = "#{hostname}/storage/st#{status.id}.ogg"
    timestamps_path = "#{hostname}/storage/st#{status.id}.json"
    pic1_path = "#{hostname}/storage/av#{avatar.id}-1.png"
    pic2_path = "#{hostname}/storage/av#{avatar.id}-2.png"

    %{
      audio: audio_path,
      timestamps: timestamps_path,
      pic1: pic1_path,
      pic2: pic2_path
    }
  end

  def create_status(user_id, attrs \\ {}) do
    av = Repo.get_by!(Avatar, user_id: user_id)
    changeset = Map.put(attrs, :avatar_id, av.id)

    validated = %Status{} |> Status.changeset(changeset)

    with {:ok, status} <- Repo.insert(validated),
         :ok <- TTS.synthesize(status, av),
         :ok <- TTS.clean(status.id) do
      {:ok, status}
    else
      {:error, err} ->
        {:error, err}

      {:tts_error, id} ->
        Repo.delete!(%Status{id: id})
        {:error, "Error while generating Text-to-speech audio!"}
    end
  end

  def update_status(%Status{} = status, attrs) do
    status
    |> Status.changeset(attrs)
    |> Repo.update()
  end

  def delete_status(%Status{} = status) do
    Repo.delete(status)
  end

  def change_status(%Status{} = status) do
    Status.changeset(status, %{})
  end
end
