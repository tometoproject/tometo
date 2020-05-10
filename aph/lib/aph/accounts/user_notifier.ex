defmodule Aph.Accounts.UserNotifier do
  import Bamboo.Email

  defp deliver(to, subject, body) do
    new_email(
      to: to,
      from: "info@tometo.org",
      subject: subject,
      text_body: body
    )
    |> Aph.Mailer.deliver_now()

    {:ok, nil}
  end

  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "your tometo confirmation instructions", """
    hello #{user.username},
    you can confirm your tometo account by visiting the url below:
    #{url}
    if you didn't create an account on tometo, please ignore this
    """)
  end

  def deliver_password_reset_instructions(user, url) do
    deliver(user.email, "your tometo password reset instructions", """
    hi #{user.username},
    you can reset your tometo password by visiting the url below:
    #{url}
    if you didn't request this change, ignore this
    """)
  end

  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "your tometo email update instructions", """
    hi #{user.username},
    you can change your email by visiting the link below:
    #{url}
    if you didn't request this change, ignore this
    """)
  end
end
