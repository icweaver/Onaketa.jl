### A Pluto.jl notebook ###
# v0.19.27

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

# ╔═╡ 55511c70-50f8-11ee-390a-0f465674a109
begin
	import Pkg
	Pkg.activate(Base.current_project())
	using Revise
end

# ╔═╡ d73d2685-7864-4512-a169-1e2b93f6c012
using Onaketa, PlutoUI

# ╔═╡ e9e1d92d-9a84-4240-ab1a-137869132e59
md"""
# Student Tutor Matching 📆

A top-level overview of all of the common times between tutors and students based on their live [whenisgood](https://whenisgood.net/) schedules. To run this notebook locally, first download the external [`Onaketa.jl`](https://github.com/icweaver/Onaketa.jl) package.

!!! tip
	See [here](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-unregistered-packages) for downloading unregistered Julia packages.
"""

# ╔═╡ 222dd02f-8b56-413a-b32f-372013a41c38
md"""
## Visualization

If running locally:
* Use the controls below to filter for different tutor-student pairs.

If viewing online:
* The brighter the cell, the more times in common there are for that pair.
* Hover over each cell to see a list of the corresponding times, and click on the cell to copy the times to your system clipboard.
"""

# ╔═╡ 9dc32763-615b-4388-a32e-88f471b64a74
@bind reset_matrix Button("Reset")

# ╔═╡ ba563197-2c9d-481e-ad46-7934e12afb47
md"""
### Download schedules
"""

# ╔═╡ 7486fc9a-4bf8-4094-8ab1-65bd3d566238
@bind URL confirm(TextField(50;default="https://whenisgood.net/2xfibm8/onaketa2023/results/qjn7dng"))

# ╔═╡ be646c2d-febe-448f-84cf-ee88072d33d0
user_info = URL |> download_schedules |> extract_times;

# ╔═╡ 67ffd46f-707a-4875-a9e3-9e98fb0eb002
md"""
### Find matches
"""

# ╔═╡ 67e4e384-8902-436a-bb8d-83d02a88e3d4
tutor_names = [
	"Chima McGruder",
	"Filipe Cerqueira",
	"Gianni Sims",
	"Gregory Cunningham",
	"Haley Carrasco",
	"Ian Weaver",
	"Pheona Williams",
]

# ╔═╡ 4af03cb3-da47-4fac-b781-ab8c0014ecb9
student_names = [
	"Aaron Sandiford",
	"Abigail Wilson",
	"Aleeya Ortega",
	"Alyssa Ortega",
	"Brooklyn Thomas",
	"Brycen Eason",
	"Channing Brisbane",
	"David Oche",
	"David Singleton",
	"Dorien Omar Hughes",
	"Ethan Barlay",
	"Jordyn Loud",
	"Judah Worthy",
	"Kaliyah Benton",
	"Keilana Alfaro",
	"Kennedy Burks",
	"Markayla Lejoi Denson",
	"Miles Banks",
	"Nahla Kaplan Rasheed",
	"Nailah Gabrielle Cannon",
	"Omega Harris",
	"Saphere",
	"Simone Hopson",
]

# ╔═╡ 70d09e5c-70b8-4792-8f1a-74a2220733f0
begin
	reset_matrix
	@mdx """
	$(@bind tutor_names_selected MultiSelect(tutor_names; default=tutor_names))
	$(@bind student_names_selected MultiSelect(student_names; default=student_names))
	"""
end

# ╔═╡ 21de3fc2-1bb1-4bee-a0a6-56a1bbf117d2
# Number of matches, corresponding tooltip data
N_common_matrix, dt_common_matrix = get_matches(user_info;
	tutor_names, student_names,
)

# ╔═╡ 4fe092a2-023d-4147-9123-94dda83bc001
p = plot_matches(N_common_matrix, dt_common_matrix;
	tutor_names,
	student_names,
	tutor_names_selected,
	student_names_selected,
)

# ╔═╡ a0c531a5-ff2a-4939-a6a5-8ad31e7aae44
md"""
## Notebook setup 🔧
"""

# ╔═╡ b2cee969-3010-45ce-b4ff-4e637477ed4e
TableOfContents()

# ╔═╡ Cell order:
# ╟─e9e1d92d-9a84-4240-ab1a-137869132e59
# ╟─222dd02f-8b56-413a-b32f-372013a41c38
# ╠═4fe092a2-023d-4147-9123-94dda83bc001
# ╟─9dc32763-615b-4388-a32e-88f471b64a74
# ╠═70d09e5c-70b8-4792-8f1a-74a2220733f0
# ╟─ba563197-2c9d-481e-ad46-7934e12afb47
# ╟─7486fc9a-4bf8-4094-8ab1-65bd3d566238
# ╠═be646c2d-febe-448f-84cf-ee88072d33d0
# ╟─67ffd46f-707a-4875-a9e3-9e98fb0eb002
# ╟─67e4e384-8902-436a-bb8d-83d02a88e3d4
# ╟─4af03cb3-da47-4fac-b781-ab8c0014ecb9
# ╠═21de3fc2-1bb1-4bee-a0a6-56a1bbf117d2
# ╟─a0c531a5-ff2a-4939-a6a5-8ad31e7aae44
# ╠═b2cee969-3010-45ce-b4ff-4e637477ed4e
# ╠═55511c70-50f8-11ee-390a-0f465674a109
# ╠═d73d2685-7864-4512-a169-1e2b93f6c012
