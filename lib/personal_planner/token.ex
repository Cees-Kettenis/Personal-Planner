defmodule PersonalPlanner.Token do
  alias PersonalPlanner.Accounts.User

  @remember_salt "s%pMo6#CK2Rp5^zi^rP!"

  def gen_remember_token(%User{id: user_id}) do
    Phoenix.Token.sign(PersonalPlannerWeb.Endpoint, @remember_salt, user_id)
  end

  def verify_remember_token(token) do
    Phoenix.Token.verify(PersonalPlannerWeb.Endpoint, @remember_salt, token, max_age: :infinity)
  end
end
