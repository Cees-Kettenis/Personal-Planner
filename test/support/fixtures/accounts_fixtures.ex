defmodule PersonalPlanner.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PersonalPlanner.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "someemail@email.com",
        name: "some name",
        password: "foo bar",
        password_confirm: "foo bar"
      })
      |> PersonalPlanner.Accounts.create_user()

    user
  end
end
