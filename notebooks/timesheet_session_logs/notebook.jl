### A Pluto.jl notebook ###
# v0.19.36

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

# ╔═╡ b458a412-8fdf-11ee-21fc-39ca9d7aec91
begin
	using CSV, DataFramesMeta, PlutoUI, Dates
	using Tectonic, PrettyTables, Printf
end

# ╔═╡ ab491bd9-50a0-45a4-9104-7935afecb5e9
@bind team_member_name Select([
	"Adia Imara",
	"Chima McGruder",
	"Filipe Cerqueira",
	"Gianni Sims",
	"Greg Cunningham",
	"Haley Carrasco",
	"Ian Weaver",
	"LaNell Williams",
]; default="Ian Weaver")

# ╔═╡ 1f8ba080-95d6-4e60-871e-1929aaf59ddf
pay_year, pay_month = (2023, 11);

# ╔═╡ 3afefd61-24af-4547-b969-2c98729e916b
const RATE = 35.00;

# ╔═╡ d141b6c5-11fc-4984-b1cf-5801426fc255
function to_latex(df; wrap_table=false)
	pretty_table(String, df;
		backend = Val(:latex),
		tf = tf_latex_double,
		show_subheader = false,
		alignment = :l,
		wrap_table = wrap_table,
		formatters = ft_printf("%.2f"),
	)
end

# ╔═╡ 8d607e10-d489-4bf3-8cff-898aa32cf36a
function format_summary(df)
	s = replace(to_latex(df; wrap_table=true),
		"\\begin{table}" => "\\begin{table}[h!]",
		"lll}" => "rrr}",
	)
	return s
end

# ╔═╡ 68df12c9-0dfc-426a-80dd-e4bf55d1d181
function format_log(df)
	s = replace(to_latex(df),
		"\\begin{table}" => "\\begin{table}[h!]",
		"tabular" => "xltabular",
		"{l" => "{\\linewidth}{l",
		"l}" => ">{\\raggedright\\arraybackslash}X}",
	)

	# Hacky workaround to align around decimal points
	s = replace(s, "{lll"=>"{llr")

	return s
end

# ╔═╡ 266ee10b-299e-42f0-b9b1-c4dd9e10a545
df = CSV.read("data/timesheet_log.csv", DataFrame; missingstring=["Other"]);

# ╔═╡ 398a2202-f6ff-4ae1-a01f-2150966e7524
gdf = @chain df begin
	@rtransform begin
		$[:y, :m, :d] = yearmonthday(:date)
		:student_name = coalesce(:student_name, :student_name_other)
	end
	# sort([:category, :student_name])
	groupby([:team_member, :y, :m]; sort=true)
end;

# ╔═╡ cecbf414-0a0c-4d45-beb9-284751d84b12
df_team_member = gdf[(team_member_name, pay_year, pay_month)];

# ╔═╡ 9e8a9329-a85d-407d-8289-c79477bf2162
team_member_pay_summary = @chain df_team_member begin
	groupby(:category)
	@combine :hours = sum(:hours)
	@transform begin
		:rate = 35.00
		:pay = RATE * :hours
	end
end

# ╔═╡ 8e00d97a-26c2-4b68-a971-e32f51a7d9d1
team_member_total_pay = sum(team_member_pay_summary.pay)

# ╔═╡ adfba62a-bf64-4506-ad6a-e371a72436cb
for row ∈ eachrow(team_member_pay_summary)
	@info row.category
end

# ╔═╡ 4df7bcbb-3412-4be6-a086-5353d46b5765
team_member_log = @select df_team_member begin
	:date
	:category
	:hours
	:student_name
	:notes
end

# ╔═╡ 815e7e18-78cb-43c5-a93a-7b8fd6b8df1a
report = """
\\documentclass{article}

\\usepackage[margin=0.5in]{geometry}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{charter}
\\usepackage{xltabular}
\\usepackage{booktabs}
\\usepackage[table]{xcolor}
\\usepackage{array}
\\usepackage{tikz}
\\usepackage{tikzpagenodes}

\\setlength{\\parindent}{0pt}
\\definecolor{onaketa-pink}{HTML}{ec008c}

\\rowcolors{1}{white}{gray!25}
\\def\\arraystretch{1.5}%

\\begin{document}
\\begin{tikzpicture}[remember picture,overlay]
   \\node[anchor=north east,inner sep=0pt] at (current page text area.north east)
              {\\includegraphics[scale=0.4]{../logo}};
\\end{tikzpicture}%
\\textbf{Pay period:} $(pay_year) $(monthname(pay_month))

\\textbf{Name:} $(team_member_name)

{\\color{onaketa-pink}\\textbf{Total (USD): $(@sprintf("%.2f", team_member_total_pay))}}

\\arrayrulecolor{onaketa-pink}
$(format_summary(team_member_pay_summary))

\\arrayrulecolor{black}
$(format_log(team_member_log))
\\end{document}
"""

# ╔═╡ ed0218a6-0ae3-483f-bd35-450a3a3e747b
let
	name = replace(team_member_name, " "=>"_")
	fname = "pay_summary_$(pay_year)_$(monthname(pay_month))_$(name).tex"
	fpath = "src"
	write("$(fpath)/$(fname)", report)
	
	mkpath("pdfs")
	tectonic() do bin
		run(`$(bin) -o pdfs $(fpath)/$(fname)`)
	end
end

# ╔═╡ 6c1f3bbf-c033-41af-ac88-7949ac2284f3
md"""
## LaTeX
"""

# ╔═╡ 693e39ab-1db5-4eb8-929e-2b177ad256b0
md"""
## Typst
"""

# ╔═╡ d9fccc47-47fc-4f88-8ac6-49e502041d09
txt = """
```typ
#set page(
  margin: 0.5in,
)

#grid(
  columns: (2fr, 1fr),
  [
    *Pay period:* 2023 November\
    *Name:* Ian Weaver\
    *Total (USD)* 516.2

    #table(
      columns: 4,
      align: (left, right, right, right),
      stroke: 0.5pt + rgb("#ec008c"),
      [*Category*], [*Hours*], [*Rate*], [*Pay*], 
      [Tutoring], [6.25], [35], [218.75],
      [Tutor Coordinator], [8.5], [35.0], [97.50],
    )
  ],
  [#image("logo.png")],
)

#table(
  columns: 5,
  align: (
    center + horizon,
    center + horizon,
    center + horizon,
    center + horizon,
    left + horizon,
  ),
  fill: (_, row) => if calc.odd(row) {luma(240)},
  stroke: 0.1pt,
  [*Date*], [*Category*], [*Hours*], [*Student*], [*Notes*],
  [2023-11-01], [Tutoring], [1.5], [David Oche], [Greene Scholars program science fair project, slope-interecept, point-slope form. Comfortable with the algebra, just needed to see the connection between these two forms for an equation for a line. A in physics, hopes to get an A in math after his next quiz.],
[2023-11-06], [Tutor Coordinator], [1.0], [], [Admin meeting],
[2023-11-06], [Tutor Coordinator], [1.0], [], [Tutor meeting],
[2023-11-07], [Tutoring], [0.5], [Nahla Kaplan Rasheed], [No-show. Update: Seemed like an honest mistake, she was retaking a test after school and lost track of time. We were able to reschedule for the following day.],
[2023-11-08], [Tutoring], [1.0], [Nahla Kaplan Rasheed], [Intro'd frequency tables. Re-took math test yesterday, will get grades next week],
[2023-11-06], [Tutoring], [0.75], [Judah Worthy], [1-D Kinematics, time of collision problems. Great handle on the algebra! ],
[2023-11-08], [Tutoring], [0.75], [Judah Worthy], [Reviewed speed vs. velocity. Feels much better with scalar vs. vector definitions now. Will do a mini-module on vector algebra next time we meet],
[2023-11-10], [Tutoring], [0.75], [David Oche], [Reviewed slope-intercept, point-slope form, and perpendicular lines. Waiting on materials for science fair project. Ended a bit early],
[2023-11-10], [Tutoring], [1.0], [Joëlle], [Subbing for Filipe. Reviewed slope-intercept, point-slope form, and perpendicular lines. Great handle on the material! Meeting again next week],
[2023-11-15], [Tutoring], [0.75], [Judah Worthy], [Reviewed motion graphs, great handle! Off for break, meeting again on the 29th],
[2023-11-16], [Tutoring], [0.5], [Nahla Kaplan Rasheed], [Reviewed simple functions for total cost of goods, and motion graphs. Hasn't received updated grades yet. Shorter session due to their family getting stuck in traffic. On break next couple weeks, will meet again November 30th (time tbd).],
[2023-11-20], [Tutor Coordinator], [2.0], [], [Admin + tutor meetings],
[2023-11-24], [Tutoring], [1.0], [David Oche], [Re-taking math test. Reviewed linear inequalities. Science fair equipment coming in the mail.],
[2023-11-29], [Tutor Coordinator], [0.25], [], [Met with Nia and Pheona to discuss Jordyn],
[2023-11-30], [Tutor Coordinator], [2.0], [], [Timesheets],
)
```
""";

# ╔═╡ a81fadc1-7916-4af8-b231-22a55a66a139
open("yee.typ", "w") do io
	write(io, "Hey\n")
	# write_logs!(io, team_member_log)
end

# ╔═╡ 64b6d9b4-da65-4b15-9b70-054e560d4837
function write_logs!(io, df)
	for row ∈ eachrow(df)
		write(io, "[$(row.date)], [$(row.category)], [$(row.hours)], [$(row.student_name)], [$(row.notes)],\n")
	end
end

# ╔═╡ 53420176-49b4-479d-996d-e0d0f7f71325
stake! = String ∘ take!

# ╔═╡ 47d52ed3-0514-476f-aed8-a8218f73361a
md"""
# Notebook setup 🔧
"""

# ╔═╡ 02b59743-a150-41e5-afab-35d54d010380
TableOfContents()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFramesMeta = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
Tectonic = "9ac5f52a-99c6-489f-af81-462ef484790f"

[compat]
CSV = "~0.10.11"
DataFramesMeta = "~0.14.1"
PlutoUI = "~0.7.54"
PrettyTables = "~2.3.1"
Tectonic = "~0.8.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "af91023f1d5dfaccb9e8a5877ad209bf2e32c593"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "793501dcd3fa7ce8d375a2c878dca2296232686e"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "PrecompileTools", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "44dbf560808d49041989b8a96cae4cffbeb7966a"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.11"

[[deps.Chain]]
git-tree-sha1 = "8c4920235f6c561e401dfe569beb8b924adad003"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.5.0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "cd67fc487743b2f0fd4380d4cbd3a24660d0eec8"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.3"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Compat]]
deps = ["UUIDs"]
git-tree-sha1 = "886826d76ea9e72b35fcd000e535588f7b60f21d"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.10.1"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "8da84edb865b0b5b0100c0666a9bc9a0b71c553c"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.15.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "DataStructures", "Future", "InlineStrings", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrecompileTools", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SentinelArrays", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "04c738083f29f86e62c8afc341f0967d8717bdb8"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.6.1"

[[deps.DataFramesMeta]]
deps = ["Chain", "DataFrames", "MacroTools", "OrderedCollections", "Reexport"]
git-tree-sha1 = "6970958074cd09727b9200685b8631b034c0eb16"
uuid = "1313f7d8-7da2-5740-9ea0-a2ca25f37964"
version = "0.14.1"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3dbd312d370723b6bb43ba9d02fc36abade4518d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.15"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "9f00e42f8d99fdde64d40c8ea5d14269a2e2c1aa"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.21"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "d75853a0bdbfb1ac815478bacd89cd27b550ace6"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.3"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "9cc2baf75c6d09f9da536ddf58eb2f29dedaf461"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.4.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "0dc7b50b8d436461be01300fd8cd45aa0274b038"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.3.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

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
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+4"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "bd7c69c7f7173097e7b5e1be07cee2b8b7447f51"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.54"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "36d8b4b899628fb92c2749eb488d884a926614d3"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.3"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.PrettyTables]]
deps = ["Crayons", "LaTeXStrings", "Markdown", "PrecompileTools", "Printf", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "88b895d13d53b5577fd53379d913b9ab9ac82660"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "0e7508ff27ba32f26cd459474ca2ede1bc10991f"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.4.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "5165dfb9fd131cf0c6957a3a7605dede376e7b63"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.0"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.StringManipulation]]
deps = ["PrecompileTools"]
git-tree-sha1 = "a04cabe79c5f01f4d723cc6704070ada0b9d46d5"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.4"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+6"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "cb76cf677714c095e535e3501ac7954732aeea2d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.11.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Tectonic]]
deps = ["Pkg"]
git-tree-sha1 = "0b3881685ddb3ab066159b2ce294dc54fcf3b9ee"
uuid = "9ac5f52a-99c6-489f-af81-462ef484790f"
version = "0.8.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "1fbeaaca45801b4ba17c251dd8603ef24801dd84"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.10.2"
weakdeps = ["Random", "Test"]

    [deps.TranscodingStreams.extensions]
    TestExt = ["Test", "Random"]

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─ab491bd9-50a0-45a4-9104-7935afecb5e9
# ╠═ed0218a6-0ae3-483f-bd35-450a3a3e747b
# ╠═1f8ba080-95d6-4e60-871e-1929aaf59ddf
# ╠═3afefd61-24af-4547-b969-2c98729e916b
# ╠═8e00d97a-26c2-4b68-a971-e32f51a7d9d1
# ╟─9e8a9329-a85d-407d-8289-c79477bf2162
# ╠═adfba62a-bf64-4506-ad6a-e371a72436cb
# ╟─4df7bcbb-3412-4be6-a086-5353d46b5765
# ╟─815e7e18-78cb-43c5-a93a-7b8fd6b8df1a
# ╟─d141b6c5-11fc-4984-b1cf-5801426fc255
# ╟─8d607e10-d489-4bf3-8cff-898aa32cf36a
# ╟─68df12c9-0dfc-426a-80dd-e4bf55d1d181
# ╠═266ee10b-299e-42f0-b9b1-c4dd9e10a545
# ╠═398a2202-f6ff-4ae1-a01f-2150966e7524
# ╠═cecbf414-0a0c-4d45-beb9-284751d84b12
# ╟─6c1f3bbf-c033-41af-ac88-7949ac2284f3
# ╟─693e39ab-1db5-4eb8-929e-2b177ad256b0
# ╠═d9fccc47-47fc-4f88-8ac6-49e502041d09
# ╠═a81fadc1-7916-4af8-b231-22a55a66a139
# ╠═64b6d9b4-da65-4b15-9b70-054e560d4837
# ╠═53420176-49b4-479d-996d-e0d0f7f71325
# ╟─47d52ed3-0514-476f-aed8-a8218f73361a
# ╠═02b59743-a150-41e5-afab-35d54d010380
# ╠═b458a412-8fdf-11ee-21fc-39ca9d7aec91
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
