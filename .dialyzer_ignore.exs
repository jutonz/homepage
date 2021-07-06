[
  # Phoenix has a couple of bad typespecs as of 1.4.11
  {"lib/client_web/router.ex", :no_return, 1},

  # Not sure what's up with these. Started with OTP 24 and Elixir 1.12
  {"lib/twitch/webhook_subscriptions/signing.ex", :no_return, 2},
  {"lib/twitch/webhook_subscriptions.ex", :no_return, 62},
  {"lib/client_web/controllers/twitch/subscriptions/callback_controller.ex", :no_return, 24}
]
