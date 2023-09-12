using HTTP, Gumbo, Cascadia
using Dates, TimeZones
using OrderedCollections, DataFramesMeta, NamedArrays
using PlutoPlotly

const DAY_TIME_FMT = dateformat"e II:MM p Z"

function download_schedules(url)
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

function match_tutor(dt_tutor, dt_student, tutor_name, student_name)
    dt_common = dt_tutor ∩ dt_student
    N = length(dt_common)
    # iszero(N) && @warn "No matches found for $(tutor_name) and $(student_name) =("
    return dt_common, N
end

function store_matches(user_info, tutors, students)
    N_common_matrix = Matrix{Int8}(undef, length.((students, tutors)))
    dt_common_matrix =  Matrix{String}(undef, length.((students, tutors))...)

    for (j, (tutor_name, dt_tutor)) ∈ enumerate(tutors)
        for (i, (student_name, dt_student)) ∈ enumerate(students)

            # Find overlap
            dt_common, N_common = match_tutor(
                dt_tutor, dt_student, tutor_name, student_name
            )

            # Store matches for plotting
            N_common_matrix[i, j] = N_common
            dt_common_matrix[i, j] = group_by_day(dt_common)

            # Show link to schedule
            # @debug Markdown.parse("""
            # **Found $(N_common) matches** \\
            # $(tutor_name) and $(student_name)
            # """)

            # Save to file for debugging
            # save_df(df_common, tutor_name, student_name)
        end
    end

    return N_common_matrix, dt_common_matrix
end

function group_by_day(dt)
    if isempty(dt)
        gdf = DataFrame(day="", time="", period="")
        return ""
    else
        gdf = @chain DataFrame([dt], [:daytime]) begin
            # Pluto ExpressionExplorer workaround
            select!(:daytime => ByRow(x -> split(x)) => [:day, :time, :period, :tz])
            # @rselect $[:day, :time, :period] = split(:daytime)
            groupby(:day)
        end

        return join(
            [
                join(
                    ["$(r.day) $(r.time) $(r.period) $(r.tz)" for r ∈ eachrow(df)], "<br>"
                )
                for df ∈ gdf
            ], "<br>-----------<br>"
        )
    end
end

function get_matches(user_info; tutor_names, student_names)
    tutor_info = OrderedDict(name => user_info[name] for name ∈ tutor_names)
    student_info = OrderedDict(name => user_info[name] for name ∈ student_names)
    N_common_matrix, dt_common_matrix = store_matches(user_info, tutor_info, student_info)
end

function plot_matches(N_common_matrix, dt_common_matrix;
    tutor_names,
    student_names,
    tutor_names_selected,
    student_names_selected,
)

    N_all = NamedArray(N_common_matrix, (student_names, tutor_names))
    N_selected = @view(N_all[student_names_selected, tutor_names_selected]).array

    dt_all = NamedArray(dt_common_matrix, (student_names, tutor_names))
    dt_selected = @view(
        dt_all[student_names_selected, tutor_names_selected]
    ).array
    customdata = js_transform(dt_selected)

    fig = Plot(Layout(
        # xaxis = attr(fixedrange=true, constrain="domain"), # Don't zoom
        # yaxis = attr(scaleanchor="x"), # Square cells
        # plot_bgcolor = "rgba(0,0,0,0)",
        title = "Tutor-student matching matrix", 
        xaxis = attr(fixedrange=true, title="Tutors"),
        yaxis = attr(
            fixedrange = true,
            # showticklabels = false,
            autorange = "reversed",
            title = "Students",
        ),
        height = 800,
    ))

    add_trace!(fig,
        heatmap(;
            x = tutor_names_selected,
            y = student_names_selected,
            z = N_selected,
            colorbar_title = "Matches",
            customdata,
            hovertemplate = """
            <b>%{x} and %{y}: %{z} matches</b>
            <br><br>%{customdata}<extra></extra>
            """,
            zmin = minimum(N_all),
            zmax = maximum(N_all),
        )
    )

    p = plot(fig)

    # Copy tooltip data to clipboard on click
    add_plotly_listener!(p, "plotly_click", "
    (e) => {
        console.log(e)
        let dt = e.points[0].customdata
        navigator.clipboard.writeText(dt.replaceAll('<br>', '\\n'))
    }
    ")

    return p
end

# Apparently javascript doesn't like matrices of strings, but list-of-lists are cool
js_transform(M) = [M[i, :] for i ∈ 1:size(M, 1)]
