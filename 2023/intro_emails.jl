### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ 3acea62a-c3cc-4456-8a05-edf0592dd010
begin
	using PlutoUI
	using MarkdownLiteral: @mdx
	using Dates
end

# ╔═╡ 3c1286e6-1add-4239-9954-8787a5e5cb9c
md"""
# Filipe
"""

# ╔═╡ 6dbd0282-4643-4f14-9e8e-cbd247feafc2
info_filipe = (
	tutor_name = "Filipe Cerqueira",
	tutor_email = "fmcerque@utmb.edu",
	tutor_position = "a Clinical Microbiology Fellow at the University of Texas Medical Branch",
)

# ╔═╡ ab911de1-076b-4304-80dd-46e668e1e97c
md"""
## Joëlle Mendy
"""

# ╔═╡ fbc5458e-6100-43d5-a277-9f961ac44654
md"""
## Maya Berhane 
"""

# ╔═╡ 1d50acc7-6640-4c49-a92b-dcbaf8f35b4f
md"""
# Reza
"""

# ╔═╡ c2cdaabf-b033-4a26-89fa-e5918aa3a093
info_reza = (
	tutor_name = "Reza Barghi",
	tutor_email = "majidrezabarghi@gmail.com",
	tutor_position = "the lead Physics, Computer Science, and Mechanical/Electrical Engineering Technician at Ohlone Community College",
)

# ╔═╡ e4efd4a2-46a8-4b15-be32-9fef14d68a8e
md"""
## Maya Reddick
"""

# ╔═╡ 6f33b85b-1b6e-488f-9faf-272214a7601d
md"""
## Azariya Smith
"""

# ╔═╡ 189c1c86-a471-4711-b363-ca1832a2d8d3
md"""
## Meshack Juma
"""

# ╔═╡ 06edbec7-94b7-447c-9e4f-fc1d55c7f94f
md"""
## Nadia Juma
"""

# ╔═╡ cf6aa82c-633b-4cb9-8f60-cd3513ed20f9
md"""
# Haley
"""

# ╔═╡ e9cabb05-a421-455f-8491-ea6eb9117def
info_haley = (
	tutor_name = "Haley Carrasco",
	tutor_email = "haleycarrasco7@gmail.com",
	tutor_position = "a medical student at Kent State University College of Podiatric Medicine",
)

# ╔═╡ cfb10e2e-41eb-41eb-92f0-63f34f548c11
md"""
## Elshadi Jahdid
"""

# ╔═╡ cc67ce30-becd-43c1-ad47-66800b0f7163
md"""
## Takiyah Jones
"""

# ╔═╡ 598b2c06-41a8-4000-99f0-6833804e840a
md"""
## Hailey Lewis
"""

# ╔═╡ 7339eef8-62f6-42ff-aab8-76807bc5426f
md"""
# Greg
"""

# ╔═╡ d8554f6e-0bfe-4cab-a94f-dfd60dc45ace
info_greg = (
	tutor_name = "Gregory Cunningham",
	tutor_email = "gcunningham@g.harvard.edu",
	tutor_position = "a GEM PhD fellow and applied physics PhD student at Harvard University as well as a graduate student researcher at Massachusetts Institute of Technology",
)

# ╔═╡ 31bb818e-a602-4e04-bb19-283d09db24df
md"""
## Justin Martin
"""

# ╔═╡ 0d58a06a-6ad3-4448-8c62-13e439054773
md"""
## Dorien Omar Hughes
"""

# ╔═╡ 16373e73-1907-4cd6-9dda-376454dd2650
md"""
## Davion Caron Brown
"""

# ╔═╡ 0f804e78-a323-4443-b400-18bd721f1fce
md"""
## Nailah Cannon
"""

# ╔═╡ 066e40df-12a0-4ad1-b09a-e481847ef296
TableOfContents(title="Intros 👋🏾")

# ╔═╡ a0e573cb-2c06-4e20-a924-acef0f0f8827
function day_time(s)
	tokens = split(s)
	day = replace(first(tokens), ',' => 's')
	time = join(tokens[4:end], " ")
	return "$(day) $(time)"
end

# ╔═╡ bb598ced-e545-4e11-bf2d-5cf55d12c2de
first_name(s) = first(split(s))

# ╔═╡ f453fdfd-ecd8-4a19-a53f-d824da7426a2
function intro(;
	parent_names,
	parent_emails,
	student_name,
	subject,
	tutor_name,
	tutor_email,
	tutor_position,
	date_start,
)
	tutor_first = first_name(tutor_name)
	student_first = first_name(student_name)
	parents_first = let
		s = first_name.(split(parent_names, ","))
		join(s, ", ")
	end
	date = day_time(date_start)
	
	@mdx """
	```
	$(parent_emails)
	info@onaketa.com, $(tutor_email)
	$(student_first) meet $(tutor_first)
	```
	
	Dear $(parents_first) and $(student_first),

	It's my pleasure to introduce you to your Onaketa tutor-mentor for $(subject), $(tutor_name) (cc'ed). $(tutor_first) is $(tutor_position). Their bio is available on our [website](https://www.onaketa.com/about). 
	
	$(tutor_first) would like to meet with $(student_first) on $(date). If this time does not work for $(student_first)'s schedule, please contact us ASAP. Otherwise, your first session will be on $(date_start).
	
	$(tutor_first) will follow up with their Zoom link and the tutor-student agreement. We ask that you read and sign the agreement before your first session.
	
	Please don't hesitate to reach out if you have questions!
	
	Best,<br>
	The Onaketa Team
	"""
end

# ╔═╡ 8f5dc354-495c-4b5e-8797-f21848f6fc36
intro(;
	parent_names = "Christine",
	parent_emails = "chrispersonal21@gmail.com",
	student_name = "Joëlle Mendy",
	subject = "Pre-Algebra",
	info_filipe...,
	date_start = "**Tuesday, January 17th at 4:00 pm PT**",
)

# ╔═╡ 0d8ff4bc-a7fe-418a-b85a-66b145a88a60
intro(;
	parent_names = "Lidite Kebede, Fesha Berhane",
	parent_emails = "lidite_kebede@yahoo.com, feshabd@yahoo.com",
	student_name = "Maya Berhane",
	subject = "Chemistry and Algebra II",
	info_filipe...,
	date_start = "**Saturday, January 21st at 10:00 am PT**",
)

# ╔═╡ 189ed825-dc67-40df-b255-cd16a23cfd24
intro(;
	parent_names = "Erin",
	parent_emails = "eyoungbloodsmith@gmail.com",
	student_name = "Maya Reddick",
	subject = "Mid-level math",
	info_reza...,
	date_start = "**Wednesday, January 18th at 6:00 pm PT**",
)

# ╔═╡ adc6f4f1-fc53-4afa-a3e1-12eabe8058ae
intro(;
	parent_names = "Aspen Maiden",
	parent_emails = "amaiden125@gmail.com",
	student_name = "Azariya Smith",
	subject = "Mid-level math",
	info_reza...,
	date_start = "**Saturday, January 21st at 2:00 pm PT**",
)

# ╔═╡ 497b7154-5352-4c56-b92a-7905efeb191f
intro(;
	parent_names = "Ken",
	parent_emails = "kjuma@Att.net",
	student_name = "Meshack Juma",
	subject = "Pre-calculus",
	info_reza...,
	date_start = "**Saturday, January 21st at 3:00 pm PT**",
)

# ╔═╡ 27284c5b-bbe2-4988-bb92-d722a1b7536e
intro(;
	parent_names = "Ken",
	parent_emails = "kjuma@Att.net",
	student_name = "Nadia Juma",
	subject = "proofs/algebra/polynomials",
	info_reza...,
	date_start = "**Saturday, January 21st at 4:00 pm PT**",
)

# ╔═╡ 98e032e7-723b-4d50-913b-a445d662d84e
intro(;
	parent_names = "Kalkidan Bekele, Jumma Jahdid",
	parent_emails = "yeab7@yahoo.com, jahdid@gmail.com",
	student_name = "Elshadi Jahdid",
	subject = "Mid-level math",
	info_haley...,
	date_start = "**Tuesday, January 17th at 4:00 pm PT**",
)

# ╔═╡ 74dc18b6-d576-4d79-832f-0178512b4382
intro(;
	parent_names = "Takiyah Jones",
	parent_emails = "takiyah.jones1@gmail.com",
	student_name = "Takiyah Jones",
	subject = "IM III",
	info_haley...,
	date_start = "**Tuesday, January 17th at 5:00 pm PT**",
)

# ╔═╡ e48d3bb6-c5f1-4b0b-ad2b-7a8b6ed4eda5
intro(;
	parent_names = "Jasmine Allen, Raul Vargas",
	parent_emails = "jnallen@scu.edu, rvraider75@gmail.com",
	student_name = "Hailey Lewis",
	subject = "Math",
	info_haley...,
	date_start = "**Friday, January 20th at 4:00 pm PT**",
)

# ╔═╡ 32bbcbb9-5e1a-4648-a3ce-090a256e3a3d
intro(;
	parent_names = "Tamiko Martin",
	parent_emails = "trixiezack@msn.com, justinmartin2827@gmail.com",
	student_name = "Justin Martin",
	subject = "Advanced math",
	info_greg...,
	date_start = "**Tuesday, January 17th at 4:00 pm PT**",

)

# ╔═╡ 60c244c3-bd9b-4e5f-b2f8-2ad9ce31a291
intro(;
	parent_names = "Rolita Monique Hill",
	parent_emails = "doriens1mom@gmail.com",
	student_name = "Dorien Omar Hughes",
	subject = "Physics",
	info_greg...,
	date_start = "**Tuesday, January 17th at 5:00 pm PT**",
)

# ╔═╡ 9c26dde8-965b-4e85-9a8f-6be4712bc81f
intro(;
	parent_names = "Devonna Johnson",
	parent_emails = "jdevonna69@yahoo.com",
	student_name = "Davion Caron Brown",
	subject = "Physics",
	info_greg...,
	date_start = "**Thursday, January 19th at 3:00 pm PT**",
)

# ╔═╡ 009a94fc-72bc-486d-b9ee-94bf09a888b8
intro(;
	parent_names = "Jeanene Cannon, Terry Cannon",
	parent_emails = "jeanene.cannon@gmail.com, tcan3001@gmail.com",
	student_name = "Nailah Cannon",
	subject = "Pre-calculus",
	info_greg...,
	date_start = "**Saturday, January 21st at 11:00 am PT**",
)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
MarkdownLiteral = "736d6165-7244-6769-4267-6b50796e6954"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
MarkdownLiteral = "~0.1.1"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "9d58e25e96b1b08d2a56ef55d933b426c706a33b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "URIs"]
git-tree-sha1 = "86cce6fd164c26bad346cc51ca736e692c9f553c"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.7"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MarkdownLiteral]]
deps = ["CommonMark", "HypertextLiteral"]
git-tree-sha1 = "0d3fa2dd374934b62ee16a4721fe68c418b92899"
uuid = "736d6165-7244-6769-4267-6b50796e6954"
version = "0.1.1"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "6466e524967496866901a78fca3f2e9ea445a559"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

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

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─3c1286e6-1add-4239-9954-8787a5e5cb9c
# ╟─6dbd0282-4643-4f14-9e8e-cbd247feafc2
# ╟─ab911de1-076b-4304-80dd-46e668e1e97c
# ╠═8f5dc354-495c-4b5e-8797-f21848f6fc36
# ╟─fbc5458e-6100-43d5-a277-9f961ac44654
# ╠═0d8ff4bc-a7fe-418a-b85a-66b145a88a60
# ╟─1d50acc7-6640-4c49-a92b-dcbaf8f35b4f
# ╟─c2cdaabf-b033-4a26-89fa-e5918aa3a093
# ╟─e4efd4a2-46a8-4b15-be32-9fef14d68a8e
# ╠═189ed825-dc67-40df-b255-cd16a23cfd24
# ╟─6f33b85b-1b6e-488f-9faf-272214a7601d
# ╠═adc6f4f1-fc53-4afa-a3e1-12eabe8058ae
# ╟─189c1c86-a471-4711-b363-ca1832a2d8d3
# ╠═497b7154-5352-4c56-b92a-7905efeb191f
# ╟─06edbec7-94b7-447c-9e4f-fc1d55c7f94f
# ╠═27284c5b-bbe2-4988-bb92-d722a1b7536e
# ╟─cf6aa82c-633b-4cb9-8f60-cd3513ed20f9
# ╟─e9cabb05-a421-455f-8491-ea6eb9117def
# ╟─cfb10e2e-41eb-41eb-92f0-63f34f548c11
# ╠═98e032e7-723b-4d50-913b-a445d662d84e
# ╟─cc67ce30-becd-43c1-ad47-66800b0f7163
# ╠═74dc18b6-d576-4d79-832f-0178512b4382
# ╟─598b2c06-41a8-4000-99f0-6833804e840a
# ╠═e48d3bb6-c5f1-4b0b-ad2b-7a8b6ed4eda5
# ╟─7339eef8-62f6-42ff-aab8-76807bc5426f
# ╠═d8554f6e-0bfe-4cab-a94f-dfd60dc45ace
# ╟─31bb818e-a602-4e04-bb19-283d09db24df
# ╠═32bbcbb9-5e1a-4648-a3ce-090a256e3a3d
# ╟─0d58a06a-6ad3-4448-8c62-13e439054773
# ╠═60c244c3-bd9b-4e5f-b2f8-2ad9ce31a291
# ╟─16373e73-1907-4cd6-9dda-376454dd2650
# ╠═9c26dde8-965b-4e85-9a8f-6be4712bc81f
# ╟─0f804e78-a323-4443-b400-18bd721f1fce
# ╠═009a94fc-72bc-486d-b9ee-94bf09a888b8
# ╟─066e40df-12a0-4ad1-b09a-e481847ef296
# ╟─3acea62a-c3cc-4456-8a05-edf0592dd010
# ╟─a0e573cb-2c06-4e20-a924-acef0f0f8827
# ╟─f453fdfd-ecd8-4a19-a53f-d824da7426a2
# ╟─bb598ced-e545-4e11-bf2d-5cf55d12c2de
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
