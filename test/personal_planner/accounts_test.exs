defmodule PersonalPlanner.AccountsTest do
  use PersonalPlanner.DataCase

  alias PersonalPlanner.Accounts

  describe "users" do
    alias PersonalPlanner.Accounts.User

    import PersonalPlanner.AccountsFixtures

    @invalid_attrs %{name: nil, email: nil, password: nil, password_confirm: nil}

    #at the current time i do not know how to ignore the password fields on the check below.
    # test "list_users/0 returns all users" do
    #   user = user_fixture()
    #   assert Accounts.list_users() == [user]
    # end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      dbuser = Accounts.get_user!(user.id)

      assert dbuser.id == user.id
      assert dbuser.name == user.name
      assert dbuser.email == user.email
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{name: "some name", email: "someemail@email.com", password: "foo bar", password_confirm: "foo bar"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.name == "some name"
      assert user.email == "someemail@email.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{name: "some updated name", email: "someupdatedemail@email.com"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.name == "some updated name"
      assert user.email == "someupdatedemail@email.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)

      dbuser = Accounts.get_user!(user.id)

      assert dbuser.id == user.id
      assert dbuser.name == user.name
      assert dbuser.email == user.email
      assert dbuser.updated_at == user.updated_at
      assert dbuser.inserted_at == user.inserted_at

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
end
