# TDAmeritrade

|      **Build Status**       | **Docs**                  |
|:---------------------------:|---------------------------|
| [![][build-img]][build-url] | [![][docs-img]][docs-url] |

## Quick example
```julia
julia> using TDAmeritrade

julia> TD_auth()
[ Info: REFRESH_TOKEN found, refreshing ACCESS_TOKEN
[ Info: Authentication completed.

julia> get_quotes(["AAPL", "FB"])[:AAPL][:lastPrice]
445.49

julia> using Dates

julia> price_history("GE", Minute(1), Day(1))[end]
JSON3.Object{Array{UInt8,1},SubArray{UInt64,1,Array{UInt64,1},Tuple{UnitRange{Int64}},true}} with 6 entries:
  :open     => 6.4
  :high     => 6.4
  :low      => 6.39
  :close    => 6.39
  :volume   => 2800
  :datetime => 1596844740000
```

## TO-DOs
The files in `src` is ~ 1-to-1 with end points listed on TD's [website](https://developer.tdameritrade.com/apis), currently some of these are missing:
- [ ] Accounts and Trading
- [x] Authentication
- [ ] Instruments
- [x] Market Hours, cr. [@Cryptum169](https://github.com/Cryptum169)
- [x] Movers
- [ ] Option Chains
- [x] Price History
- [x] Quotes
- [ ] Transaction History
- [ ] ~~User Info and Preferences~~ probably not useful
- [ ] ~~Watchlist~~ probably not useful

[build-img]: https://travis-ci.com/Moelf/TDAmeritrade.jl.svg?branch=master
[build-url]: https://travis-ci.com/Moelf/TDAmeritrade.jl
[docs-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-url]: https://moelf.github.io/TDAmeritrade.jl/dev/
