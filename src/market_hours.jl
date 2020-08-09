"""
    market_hours(market::AbstractString, date=today())
    market_hours(market::Array, date=today())

Get hours of a market in the future:
https://developer.tdameritrade.com/market-hours/apis/get/marketdata/%7Bmarket%7D/hours

Get hours of multiple markets:
https://developer.tdameritrade.com/market-hours/apis/get/marketdata/hours

`market` can be a single `String` or an `Array` or multiple `String`s

# Examples
```julia
market_hours("OPTION", "2020-08-08")
market_hours(["OPTION", "FUTURE", "EQUITY"], today() + Day(1))
```
"""
function market_hours(market::AbstractString, date=today()::Date)
    kwargs = (
        apikey = AUTH_KEY.CONSUMER_KEY, 
        date = string(date)
    )

    uri = construct_api("marketdata/$market/hours", kwargs)
    head = ["Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN]
    return @pipe HTTP.get(uri, head).body |>
                 JSON3.read |> _[Symbol(lowercase(market))]
    # While EQUITY may returns a json with EQ entry only, FUTURE and OPTION
    # will return more than one entry so the piping stops here.
end

function market_hours(market::AbstractArray{T, 1}, date=today()::Date) where T<:AbstractString
    kwargs = (
        apikey = AUTH_KEY.CONSUMER_KEY,
        markets = join(market, ","),
        date = string(date)
    )

    uri = construct_api("marketdata/hours", kwargs)
    head = ["Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN]
    return @pipe HTTP.get(uri, head).body |> JSON3.read
end
