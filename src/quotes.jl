"""
    get_quotes(ticker)
    get_quotes(ticker::Array)

Get quote of a symbol:
https://developer.tdameritrade.com/quotes/apis/get/marketdata/{symbol}/quotes

`ticker` can be a single `String` or an `Array` or multiple `String`s

# Examples
```julia
get_quotes("GE")
get_quotes(["BA","GE"])
```
"""
function get_quotes(ticker::AbstractString)
    uri = construct_api("marketdata/$ticker/quotes")
    head = ["Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN]
    # Authorization is a header
    return @pipe HTTP.get(uri, head).body |> 
                 JSON3.read |> _[Symbol(ticker)]
end

function get_quotes(tickers::AbstractArray{T,1}) where T<:AbstractString
    kwargs = Dict(
                  "symbol" => join(tickers, ","),
                 )
    uri = construct_api("marketdata/quotes", kwargs)
    head = ["Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN]
    # Authorization is a header
    return @pipe HTTP.get(uri, head).body |> 
                 JSON3.read
end
