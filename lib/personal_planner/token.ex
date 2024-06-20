defmodule PersonalPlanner.Token do
  alias PersonalPlanner.Accounts.User

  @remember_salt "s%pMo6#CK2Rp5^zi^rP!"
  @activation_salt "V9$yzC*gqr!%gFz00zCM"
  @password_reset_salt "6YwD*wLdJ5woODk3BR4F"

  def gen_remember_token(%User{id: user_id}) do
    Phoenix.Token.sign(PersonalPlannerWeb.Endpoint, @remember_salt, user_id)
  end

  def verify_remember_token(token) do
    Phoenix.Token.verify(PersonalPlannerWeb.Endpoint, @remember_salt, token, max_age: :infinity)
  end

  def gen_activation_token(%User{id: user_id}) do
    Phoenix.Token.sign(PersonalPlannerWeb.Endpoint, @activation_salt, user_id)
  end

  def verify_activation_token(token) do
    max_age = 86400 #activation tokens should not be valid for longer than 1 day.
    Phoenix.Token.verify(PersonalPlannerWeb.Endpoint, @activation_salt, token, max_age: max_age)
  end

  def gen_password_reset_token(%User{id: user_id}) do
    Phoenix.Token.sign(PersonalPlannerWeb.Endpoint, @password_reset_salt, user_id)
  end

  def verify_password_reset_token(token) do
    max_age = 7200 #password reset tokens should not be valid for longer than 2 hours.
    Phoenix.Token.verify(PersonalPlannerWeb.Endpoint, @password_reset_salt, token, max_age: max_age)
  end
end
