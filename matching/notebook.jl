### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ 5c4cc22f-b8a7-43d5-a63f-489c49d1e480
md"""
Backup work with when2meet
"""

# ╔═╡ df08f044-e182-4444-9e18-f10b8e40419f
md"""
## Tutor - student IDs
"""

# ╔═╡ d492b418-f268-4524-9149-64a3375f4e40
tutors = OrderedDict(
	"Ian"   => "18376577-X5PlH",
	"Reza"  => "18412723-MdMz3",
	"Haley" => "18417153-eBdus",
	"Greg"  => "18417148-YEnZO",
)

# ╔═╡ b60f5d3a-056a-4c46-baf4-c1f031b79b01
students = OrderedDict(
	"Alice" => "18377800-3D5I4",
	"Bob" => "18376613-r2r2c",
	"Charlie" => "18377974-jYazr",
	"Dee" => "18415463-WVm2u",
)

# ╔═╡ 844e81ea-a6a2-4866-b264-d7a070315764
const tutor_names_all = String.(keys(tutors))

# ╔═╡ 2eb1895e-f1a5-4369-85d5-0cd21817e5cf
const student_names_all = String.(keys(students))

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
		("Monday", 1),
		("Tuesday", 2),
		("Wednesday", 3),
		("Thursday", 4),
		("Friday", 5),
		("Saturday", 6),
		("Sunday", 7)
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

# ╔═╡ a6a14cfa-3f79-461e-a936-50c86726a699
function get_times(id)
	url = "https://www.when2meet.com/?$(id)"
	h = download_schedule(url)
	dt = extract_times(h)
end

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
# ╠═a6a14cfa-3f79-461e-a936-50c86726a699
# ╠═b174e7f7-44bd-4759-9de6-e3ce02e638ce
# ╟─3243160e-a652-4ec5-98e9-78f8f269f124
# ╠═c03196e7-30af-406a-95cb-d4228f18a123
# ╠═f03d34fb-50e0-4b87-ba4d-bef89e20d098
# ╠═9128dfbe-f6e3-4cb5-827c-5048639f21fd
# ╠═8d15effb-84e5-46c0-a64f-159a49e5c08f
# ╠═5500d82a-c558-4eea-9753-5519eb3896c2
# ╠═34ff5e77-45b0-4dc8-9d84-50c42580ecab
# ╠═1243e00e-e6e0-4850-92e9-c29fa5985c7e
# ╠═316fbdfa-d8fe-4e9b-9c8c-c3d52c4932b7
