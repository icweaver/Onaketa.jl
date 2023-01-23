### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

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
# ╟─3243160e-a652-4ec5-98e9-78f8f269f124
# ╠═c03196e7-30af-406a-95cb-d4228f18a123
# ╠═f03d34fb-50e0-4b87-ba4d-bef89e20d098
# ╠═9128dfbe-f6e3-4cb5-827c-5048639f21fd
# ╠═8d15effb-84e5-46c0-a64f-159a49e5c08f
# ╠═5500d82a-c558-4eea-9753-5519eb3896c2
# ╠═34ff5e77-45b0-4dc8-9d84-50c42580ecab
# ╠═1243e00e-e6e0-4850-92e9-c29fa5985c7e
# ╠═316fbdfa-d8fe-4e9b-9c8c-c3d52c4932b7
