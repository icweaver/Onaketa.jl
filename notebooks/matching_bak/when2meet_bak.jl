### A Pluto.jl notebook ###
# v0.19.46

using Markdown
using InteractiveUtils

# ╔═╡ 2d8dd507-3201-490c-9d24-af4cb9515abb
using HTTP, Gumbo, Cascadia

# ╔═╡ 5c4cc22f-b8a7-43d5-a63f-489c49d1e480
md"""
Backup work with when2meet
"""

# ╔═╡ df08f044-e182-4444-9e18-f10b8e40419f
md"""
## Tutor - student IDs
"""

# ╔═╡ d492b418-f268-4524-9149-64a3375f4e40
# tutors = OrderedDict(
# 	"Ian"   => "18376577-X5PlH",
# 	"Reza"  => "18412723-MdMz3",
# 	"Haley" => "18417153-eBdus",
# 	"Greg"  => "18417148-YEnZO",
# )

# ╔═╡ b60f5d3a-056a-4c46-baf4-c1f031b79b01
# students = OrderedDict(
# 	"Alice" => "18377800-3D5I4",
# 	"Bob" => "18376613-r2r2c",
# 	"Charlie" => "18377974-jYazr",
# 	"Dee" => "18415463-WVm2u",
# )

# ╔═╡ 844e81ea-a6a2-4866-b264-d7a070315764
# const tutor_names_all = String.(keys(tutors))

# ╔═╡ 2eb1895e-f1a5-4369-85d5-0cd21817e5cf
# const student_names_all = String.(keys(students))

# ╔═╡ a36e2860-c352-4f48-bab1-835150bd492e
function save_df(df, tutor_name, student_name)
	dirpath = "./$(tutor_name)"
	fpath = joinpath(dirpath, "$(tutor_name)_$(student_name).csv")
	mkpath(dirpath)
	@info "Saving to $(fpath)"
	CSV.write(fpath, df)
end

# ╔═╡ 00134e88-0c95-4103-b43a-d900ab6b2a4b
function day_compare(d1, d2)
	day_num = Dict((
		("Mon", 1),
		("Tue", 2),
		("Wed", 3),
		("Thu", 4),
		("Fri", 5),
		("Sat", 6),
		("Sun", 7)
	))
	return day_num[d1] < day_num[d2]
end

# ╔═╡ add32212-7b97-4f08-ad31-2e50bb506cbd
function extract_times(h; lt=day_compare)
	# Select available "green" cells from the site
	avail_times = eachmatch(
		sel"""[id*=GroupTime][style*="background: #339900"]""",
		h.root
	)
	
	# Pull out the plain-text day-time
	dt = [
		split(avail_time.attributes["onmouseover"], '"')[2]
		for avail_time ∈ avail_times
	]
	
	# These are ordered row-wise in the html body, so need to flip
	# to column-wise to order by day instead of time
	sort!(dt; by=x -> first(split(x)), lt)
	
	return dt
end

# ╔═╡ bf1ec0b6-bcfb-46d0-a198-27d94f7c777c
function download_schedule(url)
	r = HTTP.get(url)
	h = parsehtml(String(r.body))
end

# ╔═╡ a6a14cfa-3f79-461e-a936-50c86726a699
function get_times(id)
	url = "https://www.when2meet.com/?$(id)"
	h = download_schedule(url)
	dt = extract_times(h)
end

# ╔═╡ b572fc70-2fbf-44f9-9b69-790311f3c45c
get_times("26785858-OIKAz")

# ╔═╡ b174e7f7-44bd-4759-9de6-e3ce02e638ce
function yee()
# if run_common_times
# 	run_matches
	N_common_matrix = Matrix{Int8}(undef, length.((students, tutors)))
	dt_common_matrix =  Matrix{String}(undef, length.((students, tutors))...)
	student_buffer = Dict()
	for (j, (tutor_name, tutor_id)) ∈ enumerate(tutors)
		dt_tutor = get_times(tutor_id)
		@debug Markdown.parse("$(tutor_name): <https://www.when2meet.com/?$(tutor_id)>") dt_tutor
		for (i, (student_name, student_id)) ∈ enumerate(students)
			if haskey(student_buffer, student_name)
				dt_student = student_buffer[student_name]
			else
				# Download schedules
				dt_student = get_times(student_id)
				student_buffer[student_name] = dt_student
				@debug Markdown.parse("$(student_name) <https://www.when2meet.com/?$(student_id)>") dt_student
			end
			
			# Find overlap
			dt_common, N_common = match_tutor(
				dt_tutor, dt_student, tutor_name, student_name
			)

			# Store matches for plotting
			N_common_matrix[i, j] = N_common
			dt_common_matrix[i, j] = group_by_day(dt_common)
			
			# Show link to schedule
			# @debug @mdx """
			# **Found $(N_common) matches** \\
			# $(tutor_name):  \\
			# $(dt_tutor) \\
			# $(student_name):  \\
			# $(group_by_day(dt_student) |> Docs.HTML)
			# """

			# Save to file for debugging
			# save_df(df_common, tutor_name, student_name)
		end
	end
end

# ╔═╡ 3243160e-a652-4ec5-98e9-78f8f269f124
md"""
# Backup work with selenium
"""

# ╔═╡ c03196e7-30af-406a-95cb-d4228f18a123
# Markdown.parse("""
# Modified from the [discusson here](https://gist.github.com/camtheman256/3125e18ba20e90b6252678714e5102fd) to just grab the available times for a single user.

# ```javascript
# $(js)
# ```
# """)

# ╔═╡ f03d34fb-50e0-4b87-ba4d-bef89e20d098
# md"""
# !!! note
# 	It turns out that `$x()` is not defined in vanilla javascript, so `getElementByXpath` is a [workaround](https://stackoverflow.com/questions/10596417/is-there-a-way-to-get-element-by-xpath-using-javascript-in-selenium-webdriver).
# """

# ╔═╡ 9128dfbe-f6e3-4cb5-827c-5048639f21fd
# js = raw"""
# function getElementByXpath(path) {
#   return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
# }

# function getCSV() {
# 	result = "DayTime"+"\n"; 
  
# 	for(let i = 0; i < AvailableAtSlot.length; i++) {
#   		if (AvailableAtSlot[i].length == 1) {
			
# 			let slot = getElementByXpath(
# 				`//div[@id="GroupTime${TimeOfSlot[i]}"]/@onmouseover`
# 			).nodeValue;
		
# 			slot = slot.match(/.*"(.*)".*/)[1];
# 			result += slot + "\n";
# 		}
#   	}
# 	return result
# }

# return getCSV()"""

# ╔═╡ 8d15effb-84e5-46c0-a64f-159a49e5c08f
# begin
# 	options = Options()
# 	options.headless = true
# 	driver_tutor = webdriver.Firefox(; options)
# 	driver_student = webdriver.Firefox(; options)
# end

# ╔═╡ 5500d82a-c558-4eea-9753-5519eb3896c2
# function get_times(id, js, driver)
# 	url = "https://www.when2meet.com/?$(id)"
# 	driver.get(url)
# 	df = let
# 		s = pyconvert(String, driver.execute_script(js))
# 		CSV.read(IOBuffer(s), DataFrame)
# 	end
# 	return df
# end

# ╔═╡ 34ff5e77-45b0-4dc8-9d84-50c42580ecab
# @pyexec """
# from selenium import webdriver
# """

# ╔═╡ 1243e00e-e6e0-4850-92e9-c29fa5985c7e
# @py begin
# 	import selenium: webdriver
# 	import selenium.webdriver.common.by: By
# 	import selenium.webdriver.firefox.options: Options
# end

# ╔═╡ 316fbdfa-d8fe-4e9b-9c8c-c3d52c4932b7
# CondaPkg.add("selenium")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Cascadia = "54eefc05-d75b-58de-a785-1a3403f0919f"
Gumbo = "708ec375-b3d6-5a57-a7ce-8257bf98657a"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"

[compat]
Cascadia = "~1.0.2"
Gumbo = "~0.8.2"
HTTP = "~1.10.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.5"
manifest_format = "2.0"
project_hash = "3ecd70b853fc3c0b7e2be05555f3405455eb0ffa"

[[deps.AbstractTrees]]
git-tree-sha1 = "2d9c9a55f9c93e8887ad391fbae72f8ef55e1177"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.4.5"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Cascadia]]
deps = ["AbstractTrees", "Gumbo"]
git-tree-sha1 = "c0769cbd930aea932c0912c4d2749c619a263fc1"
uuid = "54eefc05-d75b-58de-a785-1a3403f0919f"
version = "1.0.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "ea32b83ca4fefa1768dc84e504cc0a94fb1ab8d1"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.2"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "dcb08a0d93ec0b1cdc4af184b26b591e9695423a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.10"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "f389674c99bfcde17dc57454011aa44d5a260a40"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "c1dd6d7978c12545b4179fb6153b9250c96b0075"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.3"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

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

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
git-tree-sha1 = "e84b3a11b9bece70d14cce63406bbc79ed3464d2"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.2"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═5c4cc22f-b8a7-43d5-a63f-489c49d1e480
# ╠═df08f044-e182-4444-9e18-f10b8e40419f
# ╠═d492b418-f268-4524-9149-64a3375f4e40
# ╠═b60f5d3a-056a-4c46-baf4-c1f031b79b01
# ╠═844e81ea-a6a2-4866-b264-d7a070315764
# ╠═2eb1895e-f1a5-4369-85d5-0cd21817e5cf
# ╠═a36e2860-c352-4f48-bab1-835150bd492e
# ╠═00134e88-0c95-4103-b43a-d900ab6b2a4b
# ╠═add32212-7b97-4f08-ad31-2e50bb506cbd
# ╠═b572fc70-2fbf-44f9-9b69-790311f3c45c
# ╠═2d8dd507-3201-490c-9d24-af4cb9515abb
# ╠═a6a14cfa-3f79-461e-a936-50c86726a699
# ╠═bf1ec0b6-bcfb-46d0-a198-27d94f7c777c
# ╟─b174e7f7-44bd-4759-9de6-e3ce02e638ce
# ╟─3243160e-a652-4ec5-98e9-78f8f269f124
# ╠═c03196e7-30af-406a-95cb-d4228f18a123
# ╠═f03d34fb-50e0-4b87-ba4d-bef89e20d098
# ╠═9128dfbe-f6e3-4cb5-827c-5048639f21fd
# ╠═8d15effb-84e5-46c0-a64f-159a49e5c08f
# ╠═5500d82a-c558-4eea-9753-5519eb3896c2
# ╠═34ff5e77-45b0-4dc8-9d84-50c42580ecab
# ╠═1243e00e-e6e0-4850-92e9-c29fa5985c7e
# ╠═316fbdfa-d8fe-4e9b-9c8c-c3d52c4932b7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
