using HTTP, Gumbo, Cascadia, Dates, TimeZones

const DAY_TIME_FMT = dateformat"e II:MM p Z"

function download_schedule(url)
    r = HTTP.get(url)
    h = parsehtml(String(r.body))
end

function extract_times(h)
    # Get contents of users/times stored in javascript tag
    script = eachmatch(
        sel"""script:containsOwn("respondents")""",
        h.root
    ) |> first |> nodeText

    # Store in [Name: Availability] pairs.
    # This is just stacked like user1, user1_availability, user2, etc.
    # so we step through line-by-line
    user_info = Dict{String, Vector{String}}()
    name_buffer = String[]
    for l ∈ split(script, "\n")
        if occursin(".name", l)
            name = get_name(l)
            push!(name_buffer, name)
        end
        if occursin(".myCanDosAll", l)
            t_unix = get_time_codes(l)
            t = t_unix .|> to_utc
            dt = Dates.format.(astimezone.(t, localzone()), DAY_TIME_FMT)
            user_info[pop!(name_buffer)] = dt
        end
    end

    return user_info
end

get_name(s) = split(s, "\"")[end-1] |> strip
get_time_codes(s) = split(s, "\"")[begin+1]
function to_utc(s)
    t = parse.(Int, split(s, ",")) .÷ 1000 |> sort .|> unix2datetime
    ZonedDateTime.(t, tz"UTC")
end
