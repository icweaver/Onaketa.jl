### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ e4512aa0-0960-11ee-15b1-8dc2c22dabaa
begin
	import Pkg
	Pkg.activate("py"; shared=true)

	using PythonCall, CondaPkg, PlutoUI

	CondaPkg.add.(("pandas", "plotly"); resolve=false)
	CondaPkg.resolve()
end

# ╔═╡ a46a4d3a-b2f8-45d6-b4d9-84f4370142a5
Resource("https://github-production-user-asset-6210df.s3.amazonaws.com/25312320/245316948-6268c571-53eb-43d4-bcb5-5f80e1e3a5cf.svg")

# ╔═╡ 21303cff-f213-4de8-8aee-da5b984c7c29
md"""
## 🌈 Mode
"""

# ╔═╡ cbc0ee52-4e86-4bd3-ae6d-a4959bfc278b
md"""
## 🌙 Mode
"""

# ╔═╡ f07d998c-8a22-44f6-918b-48f0e6a7463a
md"""
## Scary Python stuff down here 🐍
"""

# ╔═╡ b6ae9280-6a2c-4a91-9684-a05e3c6f5e5d
begin
@pyexec """
global pd, px, json, counties, df, token, make_plot

import pandas as pd
import plotly.express as px
import json

# County
with open("data/California_County_Boundaries.geojson") as f:
	counties = json.load(f)

# Sample regions to highlight (will connect to real data later)
df = pd.DataFrame({
	"State": ["CA", "CA", "CA"],
	"CountyName": ["Alameda", "Santa Clara", "Contra Costa"]
})

# Plot
token = open(".mapbox_token").read()
def make_plot(theme="stamen-watercolor"):
	fig = px.choropleth_mapbox(df, geojson=counties, locations="CountyName",
		featureidkey = "properties.CountyName",
		zoom = 11,
		color_discrete_sequence = ["#ec008c"],
		center = {"lat":37.78, "lon":-122.35},
		opacity = 0.5,
		hover_data = ["CountyName", "State"],
		labels = {"CountyName": "County"},
	)

	fig = fig.update_traces(
		marker_line_width = 3,
		showlegend = False,
	)

	fig.update_layout(
		margin = {"r":0, "t":0, "l":0, "b":0},
		mapbox_style = theme,
		mapbox_accesstoken = token,
	)
	
	return fig
"""
	
make_plot = @pyeval "make_plot"
end

# ╔═╡ c078178e-7875-4cfd-80cc-db2eb44a72e2
make_plot()

# ╔═╡ 86297aa9-abca-424f-89b9-f5e2b70f05e0
make_plot(; theme="dark")

# ╔═╡ 62a9ab93-ee3a-485f-8d7a-a4545e2b9af0
TableOfContents(title="Fun with Maps")

# ╔═╡ Cell order:
# ╟─a46a4d3a-b2f8-45d6-b4d9-84f4370142a5
# ╟─21303cff-f213-4de8-8aee-da5b984c7c29
# ╠═c078178e-7875-4cfd-80cc-db2eb44a72e2
# ╟─cbc0ee52-4e86-4bd3-ae6d-a4959bfc278b
# ╠═86297aa9-abca-424f-89b9-f5e2b70f05e0
# ╟─f07d998c-8a22-44f6-918b-48f0e6a7463a
# ╠═b6ae9280-6a2c-4a91-9684-a05e3c6f5e5d
# ╟─e4512aa0-0960-11ee-15b1-8dc2c22dabaa
# ╟─62a9ab93-ee3a-485f-8d7a-a4545e2b9af0
