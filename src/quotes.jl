"""
get_quotes(ticker)

Get quote of a symbol:
https://developer.tdameritrade.com/quotes/apis/get/marketdata/{symbol}/quotes

required:
ticker
"""
function get_quotes(ticker::AbstractString)
    kwargs = Dict(
                  "apikey" => AUTH_KEY.CONSUMER_KEY,
                  "Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN
                 )
    uri = construct_api("marketdata/$ticker/quotes", kwargs)
    return @pipe HTTP.get(uri).body |> JSON3.read |> _[Symbol(ticker)]
end

"""
get_quotes(tickers::Array)

get multiple quotes at once
"""
function get_quotes(tickers::Array{T,1}) where T<:AbstractString
    kwargs = Dict(
                  "symbol" => join(tickers, ","),
                  "apikey" => AUTH_KEY.CONSUMER_KEY,
                  "Authorization" => "Bearer "*AUTH_KEY.ACCESS_TOKEN
                 )
    uri = construct_api("marketdata/quotes", kwargs)
    return @pipe HTTP.get(uri).body |> JSON3.read
end
