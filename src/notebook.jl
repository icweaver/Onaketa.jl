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

A top-level overview of all of the common times between tutors and students based on their live [whenisgood](https://whenisgood.net/) schedules
"""

# ╔═╡ ba563197-2c9d-481e-ad46-7934e12afb47
md"""
## Download schedules
"""

# ╔═╡ 7486fc9a-4bf8-4094-8ab1-65bd3d566238
@bind URL confirm(TextField(50;default="https://whenisgood.net/2xfibm8/onaketa2023/results/qjn7dng"))

# ╔═╡ be646c2d-febe-448f-84cf-ee88072d33d0
user_info = URL |> download_schedule |> extract_times;

# ╔═╡ 67ffd46f-707a-4875-a9e3-9e98fb0eb002
md"""
## Find matches
"""

# ╔═╡ a0c531a5-ff2a-4939-a6a5-8ad31e7aae44
md"""
## Notebook setup 🔧
"""

# ╔═╡ b2cee969-3010-45ce-b4ff-4e637477ed4e
TableOfContents()

# ╔═╡ Cell order:
# ╟─e9e1d92d-9a84-4240-ab1a-137869132e59
# ╟─ba563197-2c9d-481e-ad46-7934e12afb47
# ╟─7486fc9a-4bf8-4094-8ab1-65bd3d566238
# ╠═be646c2d-febe-448f-84cf-ee88072d33d0
# ╠═67ffd46f-707a-4875-a9e3-9e98fb0eb002
# ╟─a0c531a5-ff2a-4939-a6a5-8ad31e7aae44
# ╠═b2cee969-3010-45ce-b4ff-4e637477ed4e
# ╠═55511c70-50f8-11ee-390a-0f465674a109
# ╠═d73d2685-7864-4512-a169-1e2b93f6c012
