type LanguageServer
    pipe_in
    pipe_out

    documents::Dict{String,Vector{UInt8}}
    DocStore::Dict{String,Any}

    function LanguageServer(pipe_in,pipe_out)
        new(pipe_in,pipe_out,Dict{String,Array{String,1}}(),Dict{String,Any}())
    end
end

function send(message, server)
    message_json = JSON.json(message)

    write_transport_layer(server.pipe_out,message_json)
end

function Base.run(server::LanguageServer)
    while true
        message = read_transport_layer(server.pipe_in)
        request = parse(Request, message)

        process(request, server)
    end
end