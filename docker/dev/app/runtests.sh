cd /tmp/app

mix format --check-formatted

MIX_ENV=test mix coveralls --umbrella
