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
alias PersonalPlanner.Task

passwordhash = Argon2.hash_pwd_salt("foobar")
date = DateTime.utc_now() |> DateTime.truncate(:second)
taskdate = Date.utc_today()

additional_user = %User{
  name: "Cees Kettenis",
  email: "ckettenis@gmail.com",
  password_hash: Argon2.hash_pwd_salt("specialpassword"),
  inserted_at: date,
  updated_at: date,
  admin: true,
  activated: true,
  activated_at: date
}

PersonalPlanner.Repo.insert(additional_user)

# users = for n <- 1..20 do
#   IO.inspect(n)
#   name = Faker.Pokemon.En.name()
#   date2 = date |> Timex.shift(minutes: n) |> DateTime.truncate(:second)
#   %{
#     name: name,
#     email: "#{name}-#{n}@example.com",
#     password_hash:  passwordhash,
#     inserted_at: date2,
#     updated_at: date2,
#     activated: true,
#     activated_at: date2
#   }
# end

# PersonalPlanner.Repo.insert_all(User, users)

# user = PersonalPlanner.Accounts.get_user!(1)
# tasks = for n <- 1..20 do
#   IO.inspect(n)
#   %{
#     number: Integer.to_string(:rand.uniform(1000 - 1 + 1)),
#     title: Faker.Lorem.Shakespeare.En.as_you_like_it(),
#     description: Faker.Lorem.paragraph(1..2),
#     sequence: n,
#     task_type: rem(n, 2),
#     due_date: taskdate,
#     creator_id: user.id,
#     inserted_at: date,
#     updated_at: date,
#   }
# end

# PersonalPlanner.Repo.insert_all(Task, tasks)
