function initial_auth()
    @info "open the url in browser and copy the apikey back"
    auth_url = HTTP.URI(
    host="auth.tdameritrade.com",
    scheme="https",
    path="/auth",
    query = Dict("response_type" => "code", 
                 "redirect_uri" => AUTH_KEY.CALLBACK_URI,
                 "client_id"=>"$(AUTH_KEY.CONSUMER_KEY)@AMER.OAUTHAP"
                 )
   )
end

function access_token(code)
    url = construct_api("oauth2/token",
                        Dict("grant_type" => "authorization_code",
                             "access_type" => "offline",
                             "code" => code,
                             "client_id" => AUTH_KEY.CONSUMER_KEY,
                             "redirect_uri" => AUTH_KEY.CALLBACK_URI
                            )
                       )
end
