defmodule Aph.MainTest do
  use Aph.DataCase

  alias Aph.Main

  describe "avatars" do
    alias Aph.Main.Avatar

    @valid_attrs %{
      gender: "some gender",
      language: "some language",
      name: "some name",
      pitch: 42,
      speed: 120.5
    }
    @update_attrs %{
      gender: "some updated gender",
      language: "some updated language",
      name: "some updated name",
      pitch: 43,
      speed: 456.7
    }
    @invalid_attrs %{gender: nil, language: nil, name: nil, pitch: nil, speed: nil}

    def avatar_fixture(attrs \\ %{}) do
      {:ok, avatar} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Main.create_avatar()

      avatar
    end

    test "list_avatars/0 returns all avatars" do
      avatar = avatar_fixture()
      assert Main.list_avatars() == [avatar]
    end

    test "get_avatar!/1 returns the avatar with given id" do
      avatar = avatar_fixture()
      assert Main.get_avatar!(avatar.id) == avatar
    end

    test "create_avatar/1 with valid data creates a avatar" do
      assert {:ok, %Avatar{} = avatar} = Main.create_avatar(@valid_attrs)
      assert avatar.gender == "some gender"
      assert avatar.language == "some language"
      assert avatar.name == "some name"
      assert avatar.pitch == 42
      assert avatar.speed == 120.5
    end

    test "create_avatar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Main.create_avatar(@invalid_attrs)
    end

    test "update_avatar/2 with valid data updates the avatar" do
      avatar = avatar_fixture()
      assert {:ok, %Avatar{} = avatar} = Main.update_avatar(avatar, @update_attrs)
      assert avatar.gender == "some updated gender"
      assert avatar.language == "some updated language"
      assert avatar.name == "some updated name"
      assert avatar.pitch == 43
      assert avatar.speed == 456.7
    end

    test "update_avatar/2 with invalid data returns error changeset" do
      avatar = avatar_fixture()
      assert {:error, %Ecto.Changeset{}} = Main.update_avatar(avatar, @invalid_attrs)
      assert avatar == Main.get_avatar!(avatar.id)
    end

    test "delete_avatar/1 deletes the avatar" do
      avatar = avatar_fixture()
      assert {:ok, %Avatar{}} = Main.delete_avatar(avatar)
      assert_raise Ecto.NoResultsError, fn -> Main.get_avatar!(avatar.id) end
    end

    test "change_avatar/1 returns a avatar changeset" do
      avatar = avatar_fixture()
      assert %Ecto.Changeset{} = Main.change_avatar(avatar)
    end
  end

  describe "statuses" do
    alias Aph.Main.Status

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def status_fixture(attrs \\ %{}) do
      {:ok, status} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Main.create_status()

      status
    end

    test "list_statuses/0 returns all statuses" do
      status = status_fixture()
      assert Main.list_statuses() == [status]
    end

    test "get_status!/1 returns the status with given id" do
      status = status_fixture()
      assert Main.get_status!(status.id) == status
    end

    test "create_status/1 with valid data creates a status" do
      assert {:ok, %Status{} = status} = Main.create_status(@valid_attrs)
      assert status.content == "some content"
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Main.create_status(@invalid_attrs)
    end

    test "update_status/2 with valid data updates the status" do
      status = status_fixture()
      assert {:ok, %Status{} = status} = Main.update_status(status, @update_attrs)
      assert status.content == "some updated content"
    end

    test "update_status/2 with invalid data returns error changeset" do
      status = status_fixture()
      assert {:error, %Ecto.Changeset{}} = Main.update_status(status, @invalid_attrs)
      assert status == Main.get_status!(status.id)
    end

    test "delete_status/1 deletes the status" do
      status = status_fixture()
      assert {:ok, %Status{}} = Main.delete_status(status)
      assert_raise Ecto.NoResultsError, fn -> Main.get_status!(status.id) end
    end

    test "change_status/1 returns a status changeset" do
      status = status_fixture()
      assert %Ecto.Changeset{} = Main.change_status(status)
    end
  end
end
