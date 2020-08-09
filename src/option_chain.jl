"""
    option_chain(ticker; kwargs...)
    option_chain(ticker, contractType, strikeCount, strikePrice, fromDate, toDate; kwargs)

Get option chain of a symbol:
https://developer.tdameritrade.com/option-chains/apis/get/marketdata/chains

# Examples
```julia
option_chain("AAPL", "CALL", 1, "500", today() + Day(1), today() + Day(30))
```
"""
function option_chain(ticker; kwargs...)
    kwargs = (
        kwargs...,
        symbol = ticker,
        apikey = AUTH_KEY.CONSUMER_KEY, 
    )

    uri = construct_api("marketdata/chains", kwargs)
    head = ["Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN]
    return @pipe HTTP.get(uri, head).body |>
                 JSON3.read
end

function option_chain(ticker, contractType, strikeCount, strikePrice, fromDate, toDate)
    kwargs = (
        symbol = ticker,
        contractType = contractType,
        strikeCount = strikeCount,
        strike = strikePrice,
        fromDate = string(fromDate),
        toDate = string(toDate),
        apikey = AUTH_KEY.CONSUMER_KEY
    )

    uri = construct_api("marketdata/chains", kwargs)
    head = ["Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN]
    return @pipe HTTP.get(uri, head).body |>
                 JSON3.read
end