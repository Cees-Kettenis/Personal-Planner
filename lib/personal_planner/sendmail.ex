defmodule PersonalPlanner.SendEmail do
  import Swoosh.Email

  def account_activation_email(user, activation_token) do
    url = PersonalPlannerWeb.Endpoint.url() <> "/account_activations/#{activation_token}/edit"
    logo_url = PersonalPlannerWeb.Endpoint.url() <> "/images/logo.svg"
    new()
    |> from({"noreply", "cees9000@gmail.com"}) #this must be the email you signed up with with mailer
    |> to({user.name, user.email})
    |> subject("Account Activation")
    |> html_body(
      "<html>
        <body style=\"display:flex; justify-content:center; text-align:center; background:#353535; color:#f0f0f0 !important; flex-wrap:wrap;\">
          <span style=\"width: 100%;\"> <img src=\"#{logo_url}\" style=\" width:200px; height:auto\" /> </span>
          <h1 style=\"width:100%; margin-bottom:1em;\">Hello #{user.name},</h1>
          <span style=\"width:100%; margin-bottom:1em;\">Welcome to plancraft!</span>
          <span style=\"width:100%; margin-bottom:1em;\">Your account activation link is: <a href=\"#{url}\" target=\"blank\" style=\" padding:0.25em; border: 1px solid #f0f0f0 \">link</a></span>
          <span style=\"width:100%; margin-bottom:1em;\">The link is valid for 1 day. Please activate your account before the time is up.</span>
        </body>
      </html>")
  end
end
