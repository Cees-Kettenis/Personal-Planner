defmodule PersonalPlanner.SendEmail do
  import Swoosh.Email

  def account_activation_email(user, activation_token) do
    url = PersonalPlannerWeb.Endpoint.url() <> "/account_activations/#{activation_token}/edit"
    new()
    |> from({"noreply", "noreplyplancraft@gmail.com"})
    |> to({user.name, user.email})
    |> subject("Account Activation")
    |> html_body("<h1>Hello #{user.name}</h1><br /> Your account activation link is: <br /> <a href=\"#{url}\" target=\"blank\">link</a> ")
  end
end
