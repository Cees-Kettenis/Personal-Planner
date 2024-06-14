# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PersonalPlanner.Repo.insert!(%PersonalPlanner.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PersonalPlanner.Accounts.User

passwordhash = Argon2.hash_pwd_salt("foobar")
date = DateTime.utc_now() |> DateTime.truncate(:second)

additional_user = %User{
  name: "Cees Kettenis",
  email: "ckettenis@gmail.com",
  password_hash: Argon2.hash_pwd_salt("specialpassword"),
  inserted_at: date,
  updated_at: date
}

PersonalPlanner.Repo.insert(additional_user)

# users = for n <- 1..100 do
#   IO.inspect(n)
#   name = Faker.Pokemon.En.name()
#   %{
#     name: name,
#     email: "#{name}-#{n}@example.com",
#     password_hash:  passwordhash,
#     inserted_at: date,
#     updated_at: date
#   }
# end

# PersonalPlanner.Repo.insert_all(User, users)
