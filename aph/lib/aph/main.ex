defmodule Aph.Main do
  @moduledoc """
  The context for Avatars.
  """

  import Ecto.Query, warn: false
  alias Aph.Repo

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
    case avatar |> Avatar.changeset(attrs) |> Repo.update() do
      {:ok, avatar} ->
        if !is_bitstring(pic1) do
          :ok = File.cp(pic1.path, elem(avatar_picture_path(avatar.id), 0))
        end

        if !is_bitstring(pic2) do
          :ok = File.cp(pic2.path, elem(avatar_picture_path(avatar.id), 1))
        end

        {:ok, avatar}

      {:error, _reason} = error ->
        error
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
end
