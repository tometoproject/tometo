defmodule Aph.AccountsTest do
  use Aph.DataCase

  alias Aph.Accounts

  describe "users" do
    alias Aph.Accounts.User

    @valid_attrs %{email: "some email", password: "some password", username: "some username"}
    @update_attrs %{
      email: "some updated email",
      password: "some updated password",
      username: "some updated username"
    }
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.password == "some password"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.password == "some updated password"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "invitations" do
    alias Aph.Accounts.Invitation

    @valid_attrs %{code: "some code"}
    @update_attrs %{code: "some updated code"}
    @invalid_attrs %{code: nil}

    def invitation_fixture(attrs \\ %{}) do
      {:ok, invitation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_invitation()

      invitation
    end

    test "list_invitations/0 returns all invitations" do
      invitation = invitation_fixture()
      assert Accounts.list_invitations() == [invitation]
    end

    test "get_invitation!/1 returns the invitation with given id" do
      invitation = invitation_fixture()
      assert Accounts.get_invitation!(invitation.id) == invitation
    end

    test "create_invitation/1 with valid data creates a invitation" do
      assert {:ok, %Invitation{} = invitation} = Accounts.create_invitation(@valid_attrs)
      assert invitation.code == "some code"
    end

    test "create_invitation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_invitation(@invalid_attrs)
    end

    test "update_invitation/2 with valid data updates the invitation" do
      invitation = invitation_fixture()
      assert {:ok, %Invitation{} = invitation} = Accounts.update_invitation(invitation, @update_attrs)
      assert invitation.code == "some updated code"
    end

    test "update_invitation/2 with invalid data returns error changeset" do
      invitation = invitation_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_invitation(invitation, @invalid_attrs)
      assert invitation == Accounts.get_invitation!(invitation.id)
    end

    test "delete_invitation/1 deletes the invitation" do
      invitation = invitation_fixture()
      assert {:ok, %Invitation{}} = Accounts.delete_invitation(invitation)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_invitation!(invitation.id) end
    end

    test "change_invitation/1 returns a invitation changeset" do
      invitation = invitation_fixture()
      assert %Ecto.Changeset{} = Accounts.change_invitation(invitation)
    end
  end
end
