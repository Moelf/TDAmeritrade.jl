"""
    market_hours(exchange::AbstractString, date=today())
    market_hours(exchange::Array, date=today())

Get hours of a market:
https://developer.tdameritrade.com/market-hours/apis/get/marketdata/%7Bmarket%7D/hours

Get hours of multiple markets:
https://developer.tdameritrade.com/market-hours/apis/get/marketdata/hours

`exchange` can be a single `String` or an `Array` or multiple `String`s

# Examples
```julia
market_hours("NASDAQ", "2020-08-08")
```
market_hours(["NASDAQ","NYSE"], today() - Day(1))
"""
function market_hours(exchange::AbstractString, date=today()::Date)
    request_dict = Dict(
        "apikey" => AUTH_KEY.CONSUMER_KEY,
        "date" => string(date)
    )
    uri = construct_api("marketdata/$exchange/hours", request_dict)
    head = ["Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN]
    return @pipe HTTP.get(uri, head).body |>
                 JSON3.read |> _[Symbol(lowercase(exchange))]
    # While EQUITY may returns a json with EQ entry only, FUTURE and OPTION
    # will return more than one entry so the piping stops here.
end

function market_hours(exchange::AbstractArray{T, 1}, date=today()::Date) where T<:AbstractString
    request_dict = Dict(
        "apikey" => AUTH_KEY.CONSUMER_KEY,
        "markets" => join(exchange, ","),
        "date" => string(date)
    )

    uri = construct_api("marketdata/hours", request_dict)
    head = ["Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN]
    return @pipe HTTP.get(uri, head).body |> JSON3.read
end
