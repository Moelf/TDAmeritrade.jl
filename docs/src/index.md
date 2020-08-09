# TDAmeritrade.jl

Documentation for TDAmeritrade.jl

## Getting started

* To best use this package, for example, *real-time quotes* of stocks, you have to have a [TD Ameritrade](https://tdameritrade.com/) trading account.

1. Make an account at [TD developers](https://developer.tdameritrade.com/apis), this is different from your TD trading account
2. Make an App, make sure to use "http://localhost" as your Callback URL
3. Add the **Consumer Key** of your application to `ENV["JL_TD_CONSUMER_KEY"]` (you can also add to your environment variable via ~/.bashrc or ~/.zshrc)
4. Profit, `using TDAmeritrade` and start off by running `TD_auth()` and follow the instruction.

A file will be created at `~/.JL_TD_TOKENS_CACHE` after first run to save the `REFRESH_TOKEN`.

## APIs
```@docs
TD_auth
get_movers
price_history
get_quotes
```
