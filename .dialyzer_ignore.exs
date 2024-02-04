[
  {"lib/twitch/api/authentication.ex", :pattern_match},
  # Dialyzer thinks there are only two return types when actually there are
  # multiple.
  {"lib/client/awair/monitor.ex", :pattern_match_cov}
]
