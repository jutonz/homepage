cd /tmp/app

#cd apps/client/assets && yarn lint && cd -

mix format --check-formatted

mix test
# A bug with ecto currently breaks tests the first time they are run for an
# umbrella app (something to do with migrations being run multiple times?). It
# succeeds the second time, though, so just ignore the output and exit status
# of the first round.
#/bin/bash -c "mix test; true" >> /dev/null
#mix test
