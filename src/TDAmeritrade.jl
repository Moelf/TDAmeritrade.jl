module TDAmeritrade

export TD_auth, price_history, get_quotes

using HTTP, JSON3, DelimitedFiles, Dates
using Pipe: @pipe
using Compat #for f(;kwarsg...) short-cut introduced in 1.5

include("auth.jl")
include("price_history.jl")
include("quotes.jl")

function construct_api(path, query=Dict())
    HTTP.URI(
    host="api.tdameritrade.com",
    scheme="https",
    path="/v1/$path",
    query=query
   )
end

mutable struct CREDENTIALS{T<:AbstractString}
    CONSUMER_KEY::T
    CODE::T
    ACCESS_TOKEN::T
    REFRESH_TOKEN::T
    CALLBACK_URI::T
    LAST_REFRESH::DateTime
    CREDENTIALS() = new{String}("", "", "", "","http://localhost",now()-Hour(1))
end

function __init__()
    global AUTH_KEY = CREDENTIALS()
end

end
