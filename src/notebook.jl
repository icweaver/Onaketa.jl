### A Pluto.jl notebook ###
# v0.19.40

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

# ╔═╡ b515a252-a4fa-4e35-b2e7-688682b7ac56
@mdx """
# **Student overview - Fall 2023 🚀**
"""

# ╔═╡ e9e1d92d-9a84-4240-ab1a-137869132e59
begin
title_section1 = "Student Tutor Matching 📆"
md"""
## 1) $(title_section1)

A top-level overview of all of the common times between tutors and selected students based on their live [whenisgood](https://whenisgood.net/) schedules. Most things will run directly on this site. To have full access to the interactive controls, it's recommened to run this notebook on your local computer. To do this, first download the external [`Onaketa.jl`](https://github.com/icweaver/Onaketa.jl) package.

!!! note
	To download the [unregistered Julia package](https://pkgdocs.julialang.org/v1/managing-packages/#Adding-unregistered-packages), `Onaketa.jl`, first [install Julia](https://julialang.org/downloads/) and then paste this into the [package REPL](https://docs.julialang.org/en/v1/stdlib/Pkg/):

	```julia
		pkg> add https://github.com/icweaver/Onaketa.jl
	```

	This assumes that you have [`Pluto.jl`](https://plutojl.org/) (Julia's take on Jupyter notebooks) installed into your global environment.
"""
end

# ╔═╡ 222dd02f-8b56-413a-b32f-372013a41c38
md"""
### Visualization

If viewing online:
* The brighter the cell, the more times in common there are for that pair.
* Hover over each cell to see a list of the corresponding times.
* Click on the cell to copy the times to your system clipboard (to paste into an email for example).

Additionally, if running locally:
* Use the controls below to filter for different tutor-student pairs. This might become an online feature [one day™](https://github.com/JuliaPluto/PlutoSliderServer.jl/pull/29).
* Ctrl-click to select multiple tutors/students.
* Click `Reset` to return to the default view of all tutor-student combinations.
"""

# ╔═╡ 50f2fd10-9ec4-4ecf-a694-7dc56695d3a1
md"""
!!! tip
	If the tooltip is empty but the plot shows that there should be multiple matches, there may just be too many to display at your current zoom level! Try zooming out, or just pasting the data that is automatially copied to your clipboard on click.
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
user_info = URL |> download_schedules  |> extract_times;

# ╔═╡ 67ffd46f-707a-4875-a9e3-9e98fb0eb002
md"""
### Find matches
"""

# ╔═╡ 9ede7403-19d7-4f6d-b9ef-ac9c11a84eea
student_names = [
	"Ramzi Abid",
	"Esther Nyantika",
]

# ╔═╡ 3edda429-067e-4c80-b5f8-33d9bd4c4b86
tutor_names = [
	"Ian Weaver",
	"Chima McGruder",
]

# ╔═╡ 70d09e5c-70b8-4792-8f1a-74a2220733f0
begin
	reset_matrix
	@mdx """
	$(@bind tutor_names_selected MultiSelect(tutor_names; default=tutor_names))
	$(@bind student_names_selected MultiSelect(student_names; default=student_names))
	"""
end

# ╔═╡ cd1ae99b-bacf-43ea-b5cb-40a78d177025
# Number of matches and corresponding tooltip data
N_common_matrix, dt_common_matrix = get_matches(user_info;
	tutor_names, student_names,
);

# ╔═╡ 4fe092a2-023d-4147-9123-94dda83bc001
plot_matches(N_common_matrix, dt_common_matrix;
	tutor_names,
	student_names,
	tutor_names_selected,
	student_names_selected,
)

# ╔═╡ 22a2fd6a-8ca1-4f32-88e1-1620c667ddb7
md"""
---
"""

# ╔═╡ a0c531a5-ff2a-4939-a6a5-8ad31e7aae44
md"""
## Notebook setup 🔧
"""

# ╔═╡ b2cee969-3010-45ce-b4ff-4e637477ed4e
TableOfContents()

# ╔═╡ Cell order:
# ╟─b515a252-a4fa-4e35-b2e7-688682b7ac56
# ╟─e9e1d92d-9a84-4240-ab1a-137869132e59
# ╟─222dd02f-8b56-413a-b32f-372013a41c38
# ╟─50f2fd10-9ec4-4ecf-a694-7dc56695d3a1
# ╟─4fe092a2-023d-4147-9123-94dda83bc001
# ╟─9dc32763-615b-4388-a32e-88f471b64a74
# ╟─70d09e5c-70b8-4792-8f1a-74a2220733f0
# ╟─ba563197-2c9d-481e-ad46-7934e12afb47
# ╠═7486fc9a-4bf8-4094-8ab1-65bd3d566238
# ╠═be646c2d-febe-448f-84cf-ee88072d33d0
# ╟─67ffd46f-707a-4875-a9e3-9e98fb0eb002
# ╠═9ede7403-19d7-4f6d-b9ef-ac9c11a84eea
# ╠═3edda429-067e-4c80-b5f8-33d9bd4c4b86
# ╠═cd1ae99b-bacf-43ea-b5cb-40a78d177025
# ╟─22a2fd6a-8ca1-4f32-88e1-1620c667ddb7
# ╟─a0c531a5-ff2a-4939-a6a5-8ad31e7aae44
# ╠═b2cee969-3010-45ce-b4ff-4e637477ed4e
# ╠═55511c70-50f8-11ee-390a-0f465674a109
# ╠═d73d2685-7864-4512-a169-1e2b93f6c012
