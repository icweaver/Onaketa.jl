### A Pluto.jl notebook ###
# v0.19.38

using Markdown
using InteractiveUtils

# ╔═╡ a1ca2645-efe9-4472-a70b-c5a4989c9400
begin
	using Dates, Printf
	using MarkdownLiteral: @mdx
end

# ╔═╡ 3c7b337a-66bd-468f-b7ca-a8874106ea0e
const TDY = today()

# ╔═╡ 91db6fa1-01ee-4546-8ae3-44de35ea34c3
person = (
	name = "Alice",
	amount = 100.015,
	amount_date = Date(2024, 2, 2),
	address = "123 Main St., Oakland, CA 00000, US",
)

# ╔═╡ 274360dc-6081-4c14-8da4-f91b84106c4a
r2(x) = @sprintf("%.2f", x)

# ╔═╡ f21f544a-9531-4a61-b29c-331d0b4ab491
fmt_date(dt) = Dates.format(dt, dateformat"U dd, Y")

# ╔═╡ dcaf492c-c476-11ee-2997-8d295a2527a5
function tpl_email(p)
	header_date = fmt_date(TDY)
	
	@mdx """
	$(header_date)
	
	Dear $(p.name),
	
	Thank you for your generous donation of \$$(r2(p.amount)) to Onaketa! Your contribution will help us in our work of serving black and brown students with STEM tutoring, mentorship, and other free resources.
	
	Thanks to you, we’re able to further our vision of "education without limits"—together. We truly appreciate your support.
	
	Gratefully, Onaketa
	
	Dr. Nia Imara, Founder and Director of Onaketa\\
	Dr. Siri Brown, Board Member\\
	Dr. LaNell Williams, Board Member
	
	
	---
	
	**Tax Receipt from Onaketa Inc.**

	**Name:** $(p.name)\\
	**Address:** $(p.address)\\
	**Gift Date:** $(fmt_date(p.amount_date))\\
	**Total Gift Amount:** $(r2(p.amount))
	
	*No goods or services were provided in exchange for this contribution.*

	---
	
	**Donation information:**\\
	Onaketa, Inc. is a 501(c)(3) nonprofit organization; our federal tax ID # is 85-4282111.
	Your donation is tax-deductible to the full extent provided by the law, as no goods or
	services were exchanged nor provided in consideration of this gift and/or contribution.
	"""
end

# ╔═╡ bfb61bd6-bbeb-4286-a732-fad9229b31f8
tpl_email(person)

# ╔═╡ cf7723b9-00ce-4d66-b743-d8bfcbcc23f7
function tpl_pdf(p)
	"""
	#set text(font: "TeX Gyre Schola")
	
	#align(center)[
	  #image("/logo.png", width: 50%)
	  #link("https://www.onaketa.org")[onaketa.org] |
	  #link("mailto:info@onaketa.org")
	]
	
	#let DATE_LETTER = "$(fmt_date(TDY))"
	#let NAME = "$(p.name)"
	#let AMOUNT = "\$$(r2(p.amount))"
	#let DATE_AMOUNT = "$(p.amount_date)"
	#let ADDRESS = "$(p.address)"
	
	#DATE_LETTER
	\\
	\\
	\\
	Dear #NAME,
	
	Thank you for your generous donation of #AMOUNT to Onaketa! Your contribution will help us in our work of serving black and brown students with STEM tutoring, mentorship, and other free resources.
	
	Thanks to you, we’re able to further our vision of "education without limits" --- together. We truly appreciate your support.
	\\
	\\
	Gratefully, Onaketa
	\\
	\\
	Dr. Nia Imara, Founder and Director of Onaketa\\
	Dr. Siri Brown, Board Member\\
	Dr. LaNell Williams, Board Member
	\\
	\\
	\\
	#line(length: 100%)
	*Tax Receipt from Onaketa Inc.*
	
	*Name:* #NAME\\
	*Address:* #ADDRESS\\
	*Gift Date:* #DATE_AMOUNT\\
	*Total Gift Amount:* #AMOUNT
	
	_No goods or services were provided in exchange for this contribution._
	#line(length: 100%)
	\\
	*Donation information:*\\
	Onaketa, Inc. is a 501(c)(3) nonprofit organization; our federal tax ID \\# is 85-4282111. Your donation is tax-deductible to the full extent provided by the law, as no goods or services were exchanged nor provided in consideration of this gift and/or contribution.
	"""
end

# ╔═╡ 8ddc461d-410e-435b-a05b-a268da330aec
begin
	mkpath("./src")
	# name = replace(member, " "=>"")
	# fname = "pay_summary_$(pay_date.year)_$(monthabbr(pay_date.month))_$(name)"
	fname = "Tax_receipt_letter_$(replace(person.name, ' '=>'_'))_$(TDY)"
	spath = "src/$(fname).typ"
	write(spath, tpl_pdf(person))

	mkpath("./pdfs")
	ppath = "pdfs/$(fname).pdf"
	cmd = `typst compile --root . $(spath) $(ppath)`
	run(cmd)

	@debug "Report generated for $(ppath)"

end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
MarkdownLiteral = "736d6165-7244-6769-4267-6b50796e6954"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[compat]
MarkdownLiteral = "~0.1.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0"
manifest_format = "2.0"
project_hash = "db28636f16f9fbe2dc703936785fd825c06b8f8c"

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "PrecompileTools", "URIs"]
git-tree-sha1 = "532c4185d3c9037c0237546d817858b23cf9e071"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.12"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.MarkdownLiteral]]
deps = ["CommonMark", "HypertextLiteral"]
git-tree-sha1 = "0d3fa2dd374934b62ee16a4721fe68c418b92899"
uuid = "736d6165-7244-6769-4267-6b50796e6954"
version = "0.1.1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

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

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

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
"""

# ╔═╡ Cell order:
# ╟─3c7b337a-66bd-468f-b7ca-a8874106ea0e
# ╠═91db6fa1-01ee-4546-8ae3-44de35ea34c3
# ╟─bfb61bd6-bbeb-4286-a732-fad9229b31f8
# ╟─8ddc461d-410e-435b-a05b-a268da330aec
# ╟─dcaf492c-c476-11ee-2997-8d295a2527a5
# ╟─cf7723b9-00ce-4d66-b743-d8bfcbcc23f7
# ╟─274360dc-6081-4c14-8da4-f91b84106c4a
# ╟─f21f544a-9531-4a61-b29c-331d0b4ab491
# ╠═a1ca2645-efe9-4472-a70b-c5a4989c9400
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
