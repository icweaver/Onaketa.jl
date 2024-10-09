### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ b653343f-97ad-4367-b604-c734c957a2a7
begin
	using HTTP, Gumbo, Cascadia, Dates, TimeZones
	using DataFramesMeta, CSV, OrderedCollections, NamedArrays
	using MarkdownLiteral: @mdx
	using PlutoPlotly, PlutoUI, NaturalSort
end

# ╔═╡ 5992a43e-3a89-4300-94d7-13f47dd06261
md"""
# Heatmap 🔥

Below is a top-level overview of all of the common times between tutors and students. 
* Use the controls below to filter for different tutor-student pairs.
* The brighter the cell, the more times in common there are for that pair.
* Hover over each cell to see a list of the corresponding times, and click on the cell to copy the times to your clipboard.
* Select subsets of tutor-student pairs from the menus below.

The tutor and student availability is all shared in the same calendar, so we just split these up and set the order for each here:
"""

# ╔═╡ 30c2e53f-984f-4902-9fb9-fea2f75e9ab3
@bind URL TextField(50; default="https://whenisgood.net/onaketa-sessions/results/jby2fip") |> confirm

# ╔═╡ 13788e0e-10b8-44d1-8db3-625dd6e47240
# begin
# 	reset_matrix
# 	@mdx """
# 	$(@bind tutor_names_selected MultiSelect(tutor_names; default=tutor_names))
# 	$(@bind student_names_selected MultiSelect(student_names; default=student_names))
# 	"""
# end

# ╔═╡ 6132e561-e9e9-423a-90f1-fa7b7e4f6882
# @bind reset_matrix Button("Reset")

# ╔═╡ 257cf5ff-7df6-4a23-9905-2fd6c8abe421
tutor_names = [
	"Chima McGruder",
	"Gianni Sims",
	"Haley Carrasco",
	# "Ian Weaver",
	"Justin Myles",
	"Karla Villalta",
]

# ╔═╡ b8cfab6d-1f31-4766-b373-8393ee6aee21
# let
# 	students_omit = names_unknown ∪ names_noapp ∪ tutor_names
# 	filter(∉(students_omit), keys(user_info)) |> collect |> sort
# end

# ╔═╡ d4cdbad9-c798-4753-b122-b13dfcff58ed
# Apparently javascript doesn't like matrices of strings, but list-of-lists are cool
js_transform(M) = [M[i, :] for i ∈ 1:size(M, 1)]

# ╔═╡ 6166ca3f-13da-48ba-8944-7d9b70bf1adf
md"""
# ETL ⬇
Performs the following operations:
* Pulls HTML WhenIsGood entries for all tutors and students
* Parses and extracts the day-time data (`dt`)
* Computes overlap between all tutor-student pairs

The first step is inspired from [here](https://github.com/yknot/WhenIsGoodScraper), which pointed out that all of the data we need is just squirrelled away in some javascript at the bottom. 🐿️
"""

# ╔═╡ aeadea54-6781-4784-861f-dcaeed550711
md"""
## Grab schedules
"""

# ╔═╡ 6db3afa9-bafd-4cee-b2e5-853daa80eb08
get_name(s) = split(s, "\"")[end-1] |> strip

# ╔═╡ 682d139a-9a6e-4973-b55a-aeebe465ad1d
get_time_codes(s) = split(s, "\"")[begin+1]

# ╔═╡ c0179c4b-4e8b-41f2-9ecb-666d4aedcef3
function to_utc(s)
	t = parse.(Int, split(s, ",")) .÷ 1000 |> sort .|> unix2datetime
	ZonedDateTime.(t, tz"UTC")
end

# ╔═╡ 99cf24cb-9e0e-496c-aa8a-5bb0c2cc02a1
const DAY_TIME_FMT = dateformat"e II:MM p Z"

# ╔═╡ 6f4e5641-ac06-4d89-beaf-7eb4b6c4848c
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

# ╔═╡ 97e212ea-9425-481a-add6-8fd09f00e4a2
function download_schedule(url)
	r = HTTP.get(url)
	h = parsehtml(String(r.body))
end

# ╔═╡ 3cea2780-5362-4da5-9ac7-f9b01168bb31
user_info = URL |> download_schedule |> extract_times;

# ╔═╡ 57944788-2a17-4bf0-bd02-cbe8227a4280
names_unknown = sort(filter(x -> occursin("Unknown", x), collect(keys(user_info))); lt=natural)

# ╔═╡ 14d2be49-4770-4fb2-af9c-33d7a4288981
names_noapp = sort(filter(x -> occursin("NoApp", x), collect(keys(user_info))); lt=natural)

# ╔═╡ aafaba81-aaa4-4c84-83ed-031935cf5e1e
df_dates_people = CSV.read("data/onaketa_sessions_dates_people.csv", DataFrame;
	# normalizenames = true,
	dateformat = dateformat"mm/dd/yyyy, HH:MM:SS p",
)

# ╔═╡ 67abbb7d-f243-49e3-9c8d-91e0b6a4aafe
mask = (!ismissing).(df_dates_people.:"Abe Narvaez-Olvera ")

# ╔═╡ 46db0011-8992-4e95-8fda-b965e05ea916
x = @view df_dates_people.:"Date / Time"[mask]

# ╔═╡ cd4f9e05-5029-4a2a-858f-dc782a645913
DAY_TIME_FMT2 = dateformat"e II:MM p PT"

# ╔═╡ 300e79dc-ce4a-4b51-ac83-edeb0979e61d
Dates.format.(x, DAY_TIME_FMT2)

# ╔═╡ 43232ad3-a833-4e02-8c54-026d77011434
md"""
## Find matches
"""

# ╔═╡ a65071a1-be75-406f-b8bc-05268ea55f1e
df_student_applicants = let
	df = CSV.read("./data/student_applications.csv", DataFrame;
		# header = 2,	
	)
	@rsubset df :"Submitted at" ≥ Date(2024, 07, 01) 
end;

# ╔═╡ cc75ac1c-6cef-4b9d-9d9e-638d7b359f7b
student_names = (@rsubset df_student_applicants :internal_status == "accept"
).student_name |> sort;

# ╔═╡ 5ba6bed0-ae7a-48e2-a373-f4386332df71
function match_tutor(dt_tutor, dt_student, tutor_name, student_name)
	dt_common = dt_tutor ∩ dt_student
	N = length(dt_common)
	# iszero(N) && @warn "No matches found for $(tutor_name) and $(student_name) =("
	return dt_common, N
end

# ╔═╡ fa087248-6914-4ebd-81f4-3d580e4f403d
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

# ╔═╡ fb2acc7f-7aea-4377-a37f-be5832d4edd3
function store_matches(user_info, tutors, students)
	@info user_info, tutors, students
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

# ╔═╡ 24b79620-2d48-4946-862e-a7d17cbfd482
begin
	tutor_info = OrderedDict(name => user_info[name] for name ∈ tutor_names)
	# student_names = setdiff(keys(user_info), tutor_names) |> collect |> sort
	student_info = OrderedDict(name => user_info[name] for name ∈ student_names)
	N_common_matrix, dt_common_matrix = store_matches(user_info, tutor_info, student_info)
end;

# ╔═╡ e077cacc-e638-49bc-9e50-62a43a7af574
begin
	N_all = NamedArray(N_common_matrix, (student_names, tutor_names))
	N_selected = @view(N_all[student_names, tutor_names]).array
	
	dt_all = NamedArray(dt_common_matrix, (student_names, tutor_names))
	dt_selected = @view(
		dt_all[student_names, tutor_names]
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
			x = tutor_names,
			y = student_names,
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
end

# ╔═╡ fa5f1811-40a4-4572-bc7a-fbbf2f9a3c24
open("./matching.html", "w") do io
	PlutoPlotly.PlotlyBase.to_html(io, p.Plot;
		full_html = false,
	)
end

# ╔═╡ 0ebce986-c7c6-4619-8779-c5e7d6f2e8ac
md"""
# Packages 📦
"""

# ╔═╡ 168567e7-5c80-4ff3-b094-8e58f6b3ce58
TableOfContents(title="Tutor-student matching")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
Cascadia = "54eefc05-d75b-58de-a785-1a3403f0919f"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
Gumbo = "708ec375-b3d6-5a57-a7ce-8257bf98657a"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
MarkdownLiteral = "736d6165-7244-6769-4267-6b50796e6954"
NamedArrays = "86f7a689-2022-50b4-a561-43c23ac3c673"
NaturalSort = "c020b1a1-e9b0-503a-9c33-f039bfc54a85"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
TimeZones = "f269a46b-ccf7-5d73-abea-4c690281aa53"

[compat]
CSV = "~0.10.14"
Cascadia = "~1.0.2"
DataFramesMeta = "~0.15.3"
Gumbo = "~0.8.2"
HTTP = "~1.10.8"
MarkdownLiteral = "~0.1.1"
NamedArrays = "~0.10.3"
NaturalSort = "~1.0.0"
OrderedCollections = "~1.6.3"
PlutoPlotly = "~0.5.0"
PlutoUI = "~0.7.60"
TimeZones = "~1.18.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.0"
manifest_format = "2.0"
project_hash = "0cd6ab24b374fa41248edc66c5fc09cfa5e61e4f"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.BaseDirs]]
git-tree-sha1 = "cb25e4b105cc927052c2314f8291854ea59bf70a"
uuid = "18cc8868-cbac-4acf-b575-c8ff214dc66f"
version = "1.2.4"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "6c834533dc1fabd820c1db03c839bf97e45a3fab"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.14"

[[deps.Cascadia]]
deps = ["AbstractTrees", "Gumbo"]
git-tree-sha1 = "c0769cbd930aea932c0912c4d2749c619a263fc1"
uuid = "54eefc05-d75b-58de-a785-1a3403f0919f"
version = "1.0.2"

[[deps.Chain]]
git-tree-sha1 = "9ae9be75ad8ad9d26395bf625dea9beac6d519f1"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.6.0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "b5278586822443594ff615963b0c09755771b3e0"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.26.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "362a287c3aa50601b0bc359053d5c2468f0e7ce0"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.11"

[[deps.Combinatorics]]
git-tree-sha1 = "08c8b6831dc00bfea825826be0bc8336fc369860"
uuid = "861a8166-3701-5b0c-9a16-15d98fcdc6aa"
version = "1.0.2"

[[deps.CommonMark]]
deps = ["Crayons", "PrecompileTools"]
git-tree-sha1 = "3faae67b8899797592335832fccf4b3c80bb04fa"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.15"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "fb61b4812c49343d7ef0b533ba982c46021938a6"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.7.0"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport", "TableMetadataTools"]
git-tree-sha1 = "7042a6ad5910dc9edeae814e1110209752a1c996"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.15.3"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates"]
git-tree-sha1 = "7878ff7172a8e6beedd1dea14bd27c3c6340d361"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.22"
weakdeps = ["Mmap", "Test"]

    [deps.FilePathsBase.extensions]
    FilePathsBaseMmapExt = "Mmap"
    FilePathsBaseTestExt = "Test"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"
version = "1.11.0"

[[deps.Gumbo]]
deps = ["AbstractTrees", "Gumbo_jll", "Libdl"]
git-tree-sha1 = "a1a138dfbf9df5bace489c7a9d5196d6afdfa140"
uuid = "708ec375-b3d6-5a57-a7ce-8257bf98657a"
version = "0.8.2"

[[deps.Gumbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "29070dee9df18d9565276d68a596854b1764aa38"
uuid = "528830af-5a63-567c-a44a-034ed33b8444"
version = "0.10.2+0"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "d1d712be3164d61d1fb98e7ce9bcbc6cc06b45ed"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.8"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InlineStrings]]
git-tree-sha1 = "45521d31238e87ee9f9732561bfee12d4eebd52d"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.2"

    [deps.InlineStrings.extensions]
    ArrowTypesExt = "ArrowTypes"
    ParsersExt = "Parsers"

    [deps.InlineStrings.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
    Parsers = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "f389674c99bfcde17dc57454011aa44d5a260a40"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "50901ebc375ed41dbf8058da26f9de442febbbec"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MarkdownLiteral]]
deps = ["CommonMark", "HypertextLiteral"]
git-tree-sha1 = "0d3fa2dd374934b62ee16a4721fe68c418b92899"
uuid = "736d6165-7244-6769-4267-6b50796e6954"
version = "0.1.1"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "2c140d60d7cb82badf06d8783800d0bcd1a7daa2"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.8.1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NamedArrays]]
deps = ["Combinatorics", "DataStructures", "DelimitedFiles", "InvertedIndices", "LinearAlgebra", "Random", "Requires", "SparseArrays", "Statistics"]
git-tree-sha1 = "58e317b3b956b8aaddfd33ff4c3e33199cd8efce"
uuid = "86f7a689-2022-50b4-a561-43c23ac3c673"
version = "0.10.3"

[[deps.NaturalSort]]
git-tree-sha1 = "eda490d06b9f7c00752ee81cfa451efe55521e21"
uuid = "c020b1a1-e9b0-503a-9c33-f039bfc54a85"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+1"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "Artifacts", "BaseDirs", "Colors", "Dates", "Downloads", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "Pkg", "PlotlyBase", "Reexport", "TOML"]
git-tree-sha1 = "653b48f9c4170343c43c2ea0267e451b68d69051"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.5.0"

    [deps.PlutoPlotly.extensions]
    PlotlyKaleidoExt = "PlotlyKaleido"
    UnitfulExt = "Unitful"

    [deps.PlutoPlotly.weakdeps]
    PlotlyKaleido = "f2990250-8cf9-495f-b13a-cce12b45703c"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "1101cd475833706e4d0e7b122218257178f48f34"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "ff11acffdb082493657550959d4feb4b6149e73a"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.5"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"
weakdeps = ["SparseArrays"]

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a6b1675a536c5ad1a60e5a5153e1fee12eb146e3"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.4.0"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.7.0+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TZJData]]
deps = ["Artifacts"]
git-tree-sha1 = "36b40607bf2bf856828690e097e1c799623b0602"
uuid = "dc5dba14-91b3-4cab-a142-028a31da12f7"
version = "1.3.0+2024b"

[[deps.TableMetadataTools]]
deps = ["DataAPI", "Dates", "TOML", "Tables", "Unitful"]
git-tree-sha1 = "c0405d3f8189bb9a9755e429c6ea2138fca7e31f"
uuid = "9ce81f87-eacc-4366-bf80-b621a3098ee2"
version = "0.1.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "Mocking", "Printf", "Scratch", "TZJData", "Unicode", "p7zip_jll"]
git-tree-sha1 = "8323074bc977aa85cf5ad71099a83ac75b0ac107"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.18.1"

    [deps.TimeZones.extensions]
    TimeZonesRecipesBaseExt = "RecipesBase"

    [deps.TimeZones.weakdeps]
    RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d95fe458f26209c66a187b1114df96fd70839efd"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.21.0"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─5992a43e-3a89-4300-94d7-13f47dd06261
# ╟─30c2e53f-984f-4902-9fb9-fea2f75e9ab3
# ╠═e077cacc-e638-49bc-9e50-62a43a7af574
# ╠═fa5f1811-40a4-4572-bc7a-fbbf2f9a3c24
# ╠═13788e0e-10b8-44d1-8db3-625dd6e47240
# ╟─6132e561-e9e9-423a-90f1-fa7b7e4f6882
# ╠═57944788-2a17-4bf0-bd02-cbe8227a4280
# ╠═14d2be49-4770-4fb2-af9c-33d7a4288981
# ╠═257cf5ff-7df6-4a23-9905-2fd6c8abe421
# ╠═b8cfab6d-1f31-4766-b373-8393ee6aee21
# ╟─d4cdbad9-c798-4753-b122-b13dfcff58ed
# ╟─6166ca3f-13da-48ba-8944-7d9b70bf1adf
# ╟─aeadea54-6781-4784-861f-dcaeed550711
# ╠═3cea2780-5362-4da5-9ac7-f9b01168bb31
# ╟─6db3afa9-bafd-4cee-b2e5-853daa80eb08
# ╟─682d139a-9a6e-4973-b55a-aeebe465ad1d
# ╟─c0179c4b-4e8b-41f2-9ecb-666d4aedcef3
# ╠═99cf24cb-9e0e-496c-aa8a-5bb0c2cc02a1
# ╠═6f4e5641-ac06-4d89-beaf-7eb4b6c4848c
# ╟─97e212ea-9425-481a-add6-8fd09f00e4a2
# ╠═aafaba81-aaa4-4c84-83ed-031935cf5e1e
# ╠═67abbb7d-f243-49e3-9c8d-91e0b6a4aafe
# ╠═46db0011-8992-4e95-8fda-b965e05ea916
# ╠═300e79dc-ce4a-4b51-ac83-edeb0979e61d
# ╠═cd4f9e05-5029-4a2a-858f-dc782a645913
# ╟─43232ad3-a833-4e02-8c54-026d77011434
# ╠═24b79620-2d48-4946-862e-a7d17cbfd482
# ╠═a65071a1-be75-406f-b8bc-05268ea55f1e
# ╠═cc75ac1c-6cef-4b9d-9d9e-638d7b359f7b
# ╟─5ba6bed0-ae7a-48e2-a373-f4386332df71
# ╠═fa087248-6914-4ebd-81f4-3d580e4f403d
# ╠═fb2acc7f-7aea-4377-a37f-be5832d4edd3
# ╟─0ebce986-c7c6-4619-8779-c5e7d6f2e8ac
# ╠═b653343f-97ad-4367-b604-c734c957a2a7
# ╠═168567e7-5c80-4ff3-b094-8e58f6b3ce58
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
