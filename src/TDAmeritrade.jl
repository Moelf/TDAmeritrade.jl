module TDAmeritrade

export inter_auth, price_history, get_quotes

using HTTP, JSON3, Pipe, DelimitedFiles, Dates

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

mutable struct AUTH_KEYS{T<:AbstractString}
    CONSUMER_KEY::T
    CODE::T
    ACCESS_TOKEN::T
    REFRESH_TOKEN::T
    CALLBACK_URI::T
    LAST_REFRESH::DateTime
    AUTH_KEYS() = new{String}("", "", "", "","http://localhost",now()-Hour(1))
end

AUTH_KEY = AUTH_KEYS()
end
