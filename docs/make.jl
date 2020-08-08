using Documenter
using TDAmeritrade

makedocs(
    modules = [TDAmeritrade],
    sitename = "TDAmeritrade",
    authors="Jerry Ling",
    format = Documenter.HTML(),
    doctest=false,
    clean=true
)

deploydocs(deps=Deps.pip("mkdocs", "python-markdown-math"),
           repo="github.com/Moelf/TDAmeritrade.jl.git",
           devbranch="master",
           devurl="dev",
           versions=["stable" => "v^", "v#.#", "dev" => "dev"])
