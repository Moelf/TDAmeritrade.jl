#ntvwyo1fZelbFQPPqwt8N1LBZ7xi8GLwl%2BMJHZPZRhOM6Jdg0ieIrANAOFWVaKYX%2FjhUo5NcVVeEY24ZH01zEqlLzjsPsYtco48TuSEsNEFWx%2Flb6GxLG5zMy2tjHTi%2FvOHDIW2BrNpfkzqVZOPpke3F%2BqBETRIxJvjzHQbCaMCkd9ym%2BOdpOLzhOqbTtQyyERrvbypKfKuTvuEHq1T1qjM1yhLWrzkVkEKUj6n4XGXsr36nZC18n0ybVQFY4dMSA1%2BrEzEO0CCFyuqOXGTuP70IbXX6T8RpvQQU2ScCsd%2B0wW%2Fi8%2FwfGWmfGLnktkQrJ2zeC00IkbctNnhZmVMibOJylcQekcJECpLjJXCTcdWHPvzuACayrVT5ezPmesFyKHZCmDVLVj4BlrdxOm4n%2FkMA1HKYJ5r%2FBYSoPKDVuUbOPvu73kOe8qdqcNs100MQuG4LYrgoVi%2FJHHvl7pUvsiMTETvU5PeSpkVcCivi9sEYYmTLOQNaXxQ8izrs2SAlQw0cfiGtoGp6s8U99sgsjzombJEGgJnbcIGXKNJQh6aHrCU%2F3d6UclcAQ3Ydg4gV%2B6lu9msxTmk1uAvyjzwcaPos5%2BitPu%2FrZeGW3MrRiNLSS3gO3vIkxJsGxQZr29A30V56Hsw%2FNAjrp1Dd0aF7oCVqSj%2BeBOmuzqTZnQu2r4bseA767%2B%2BiMBeQwXODhKA97K4sJCu8ciku8e4KFc7kLCwphXrbW8VvJCYaFYrfXcyYYHemLSKxJRzPqfMj9lOXE7LO7kFqgFf8YQT0OzOuTZIWsbGhyI%2FuBUj24xlK2HWMPkh8Q0ud0%2BOqRxg2sLTgiKelRBqftjQACknO%2BSrr05nmmaqa80hcE8bn1tTxHA3YakYtyyBoOaU6qICX5NV5sgIlPkZjxzk%3D212FD3x19z9sWBHDJACbC00B75E
module TDAmeritrade

using HTTP

include("auth.jl")
include("price_history.jl")

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
    AUTH_KEYS() = new{String}("", "", "", "","http://localhost")
end


AUTH_KEY = AUTH_KEYS()
AUTH_KEY.CONSUMER_KEY = try
    ENV["JL_TD_CONSUMER_KEY"]
catch
    error("Key environmen variable JL_TD_CONSUMER_KEY not found")
end

AUTH_KEY.CODE = try
    ENV["JL_TD_CODE"]
catch
    @info "first time auth needs manual invervention"
    ""
end

if AUTH_KEY.CODE |> isempty
    @info initial_auth()
    @info "paste code=<blah> from address bar to here"
    print("code:")
    AUTH_KEY.CODE = readline() |> HTTP.URIs.unescapeuri
end


end
