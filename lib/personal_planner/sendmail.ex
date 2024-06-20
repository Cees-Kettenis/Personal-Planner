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
                    <head>
                      <style>
                        body {
                          margin: 0;
                          padding: 0;
                          background: #353535;
                          color: #f0f0f0;
                          font-family: Arial, sans-serif;
                          text-align: center;
                        }
                        .container {
                          width: 100%;
                          max-width: 600px;
                          margin: 0 auto;
                          padding: 20px;
                        }
                        .logo {
                          width: 200px;
                          height: auto;
                          display: block;
                          margin: 0 auto;
                        }
                        .header, .content, .footer {
                          width: 100%;
                          margin-bottom: 1em;
                        }
                        .link {
                          padding: 0.25em;
                          border: 1px solid #f0f0f0;
                          color: #f0f0f0;
                          text-decoration: none;
                        }
                        .link:hover {
                          background: #f0f0f0;
                          color: #353535;
                        }
                      </style>
                    </head>
                    <body>
                      <div class=\"container\">
                        <img src=\"#{logo_url}\" alt=\"Logo\" class=\"logo\" style=\"width:200px; height:auto;\"  />
                        <h1 class=\"header\">Hello #{user.name},</h1>
                        <p class=\"content\">Welcome to plancraft!</p>
                        <p class=\"content\">Your account activation link is:
                          <a href=\"#{url}\" target=\"_blank\" class=\"link\">link</a>
                        </p>
                        <p class=\"footer\">The link is valid for 1 day. Please activate your account before the time is up.</p>
                      </div>
                    </body>
                  </html>")
  end

  def password_reset_email(user, reset_token) do
    url = PersonalPlannerWeb.Endpoint.url() <> "/password_resets/#{reset_token}/edit"
    logo_url = PersonalPlannerWeb.Endpoint.url() <> "/images/logo.svg"
    new()
    |> from({"noreply", "cees9000@gmail.com"}) #this must be the email you signed up with with mailer
    |> to({user.name, user.email})
    |> subject("Password reset")
    |> html_body(
                  "<html>
                    <head>
                      <style>
                        body {
                          margin: 0;
                          padding: 0;
                          background: #353535;
                          color: #f0f0f0;
                          font-family: Arial, sans-serif;
                          text-align: center;
                        }
                        .container {
                          width: 100%;
                          max-width: 600px;
                          margin: 0 auto;
                          padding: 20px;
                        }
                        .logo {
                          width: 200px;
                          height: auto;
                          display: block;
                          margin: 0 auto;
                        }
                        .header, .content, .footer {
                          width: 100%;
                          margin-bottom: 1em;
                        }
                        .link {
                          padding: 0.25em;
                          border: 1px solid #f0f0f0;
                          color: #f0f0f0;
                          text-decoration: none;
                        }
                        .link:hover {
                          background: #f0f0f0;
                          color: #353535;
                        }
                      </style>
                    </head>
                    <body>
                      <div class=\"container\">
                        <img src=\"#{logo_url}\" alt=\"Logo\" class=\"logo\" style=\"width:200px; height:auto;\"  />
                        <h1 class=\"header\">Hello #{user.name},</h1>
                        <p class=\"content\">Please click the link to reset your password:
                                            <a href=\"#{url}\" target=\"_blank\" class=\"link\">link</a>
                        </p>
                        <p class=\"footer\">The link is valid for 2 hours. Please reset your password time is up.</p>
                      </div>
                    </body>
                  </html>")
  end
end
