### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ e49707d6-bf6f-11ed-0957-d5b450fb98e1
begin
	import Pkg
	Pkg.activate(Base.current_project())
	using DataFramesMeta, CSV
	using MarkdownLiteral: @mdx
end

# ╔═╡ bd54170f-9faf-4d1b-854a-9c78ffbe71c8
df = CSV.read("data/responses_2023.csv", DataFrame)

# ╔═╡ bee2eb8a-ccbc-496d-b5c5-146e4c7178f3
names(df)

# ╔═╡ 08a403e2-c374-4b39-888c-d5fe92f5d060
brs = ByRow(strip)

# ╔═╡ 7f03b877-c985-4d47-ad87-4d5f94760f2b
sl = strip ∘ lowercase

# ╔═╡ 6b59efda-31ba-4275-b4cd-9b313fb107e0
function clean_subject_cat(s)
	s_lower = sl(s)
	
	s_cleaned = if occursin("basic math", s_lower)
		"basic math"
	elseif occursin("mid-level math", s_lower)
		"mid-level math"
	elseif occursin("advanced math", s_lower)
		"advanced math"
	elseif occursin("science", s_lower)
		"science"
	else
		s_lower
	end
end

# ╔═╡ 30d106e4-c199-4d48-a024-89c3f54c02c3
function clean_student_race_ethnicity(s)
	s_lower = sl(s)

	s_cleaned = if occursin("black", s_lower)
		"Black or African American"
	elseif occursin(r"racial|and", s_lower)
		"Multiracial"
	elseif occursin("latin", s_lower)
		"Latinx/Latina/Latino (non-white Hispanic)"
	elseif occursin("native american", s_lower)
		"Native American"
	elseif occursin("Southeast Asian or Pacific Islander", s_lower)
		"Southeast Asian or Pacific Islander"
	else
		s_lower
	end
end

# ╔═╡ 51814541-cb95-49db-84bf-45b02600f3fa
select(df,
	:student_name => brs,
	:student_email,
	:student_address => brs,
	:school_name => brs,
	:subject_cat => ByRow(clean_subject_cat),
	:student_grade,
	:student_race_ethnicity => ByRow(clean_student_race_ethnicity),
	:guardian1_name => brs,
	:guardian1_email => brs,
	:guardian2_name,
	:guardian2_email,
	:timestamp,
)

# ╔═╡ Cell order:
# ╠═bd54170f-9faf-4d1b-854a-9c78ffbe71c8
# ╠═bee2eb8a-ccbc-496d-b5c5-146e4c7178f3
# ╠═51814541-cb95-49db-84bf-45b02600f3fa
# ╠═08a403e2-c374-4b39-888c-d5fe92f5d060
# ╠═6b59efda-31ba-4275-b4cd-9b313fb107e0
# ╟─30d106e4-c199-4d48-a024-89c3f54c02c3
# ╠═7f03b877-c985-4d47-ad87-4d5f94760f2b
# ╠═e49707d6-bf6f-11ed-0957-d5b450fb98e1
