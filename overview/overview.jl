### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ fe44f5bc-b1af-11ed-16ce-d3cc5b3b856b
begin
	using AlgebraOfGraphics, CairoMakie
	using DataFramesMeta, CSV, Dates, PrettyTables
	using MarkdownLiteral: @mdx
	using PlutoUI
	using AlgebraOfGraphics: opensans, firasans

	set_aog_theme!()
	update_theme!(
		Theme(
			Axis = (;
				titlesize = 36,
				titlealign = :left,
				subtitlesize = 24,
				subtitlecolor = :grey,
				subtitlefont = firasans("Light"),
			)
		)
	)
end

# ╔═╡ d1984f0a-2291-4d2b-a0de-6ff3704d5c1c
df_raw = CSV.read("anon.csv", DataFrame)

# ╔═╡ a86bc0dc-a61d-4f71-8547-9e9b732ef683
describe(df_raw, :nuniqueall, :nmissing, :eltype)

# ╔═╡ ce9f0b77-9183-4a6a-b9d0-d30f1cfc3bac
df = @rsubset df_raw !(:drop_status)

# ╔═╡ b91501a8-c3ab-47b5-95ea-618c8c02d446
df_sem = @chain df begin
	stack(r"Spring|Fall")
	groupby(:variable)
	combine(:value => count; renamecols=false)
	@rtransform begin 
		# :variable = fmt_sem(:variable)
		:value_str = string(:value)
	end
end

# ╔═╡ 781ee8d2-dcdf-46b3-bb31-393b03b97924
md"""
## Semester
"""

# ╔═╡ 8d602daf-01a9-466f-8d65-298353a1493c
let
	# ax_sem = Axis(fig[1, 1])
	plt = data(df_sem) * mapping(
		:variable => sorter(df_sem.variable) => "",
		:value => "";
		text = :value_str => verbatim,
		# color = :variable => sort_order,
	) * (visual(BarPlot) + visual(Makie.Text; align=(:center, :top), color=:white))

	draw(plt;
		axis = (;
			title = "Students served",
			subtitle = "Number of active students each semester"),
	)
	
end |> as_svg

# ╔═╡ Cell order:
# ╠═d1984f0a-2291-4d2b-a0de-6ff3704d5c1c
# ╠═a86bc0dc-a61d-4f71-8547-9e9b732ef683
# ╠═ce9f0b77-9183-4a6a-b9d0-d30f1cfc3bac
# ╠═b91501a8-c3ab-47b5-95ea-618c8c02d446
# ╟─781ee8d2-dcdf-46b3-bb31-393b03b97924
# ╟─8d602daf-01a9-466f-8d65-298353a1493c
# ╠═fe44f5bc-b1af-11ed-16ce-d3cc5b3b856b
