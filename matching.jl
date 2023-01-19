### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ b653343f-97ad-4367-b604-c734c957a2a7
begin
	using DataFrames, CSV
	using MarkdownLiteral: @mdx
end

# ╔═╡ 14083450-7c1a-4483-aa26-75a793576eb4
df_ian = let
	s = """
Time,Avail
Monday 09:00:00 AM,0
Monday 09:15:00 AM,0
Monday 09:30:00 AM,0
Monday 09:45:00 AM,0
Monday 10:00:00 AM,1
Monday 10:15:00 AM,1
Monday 10:30:00 AM,1
Monday 10:45:00 AM,1
Monday 11:00:00 AM,1
Monday 11:15:00 AM,1
Monday 11:30:00 AM,0
Monday 11:45:00 AM,0
Monday 12:00:00 PM,0
Monday 12:15:00 PM,0
Monday 12:30:00 PM,0
Monday 12:45:00 PM,0
Monday 01:00:00 PM,0
Monday 01:15:00 PM,0
Monday 01:30:00 PM,0
Monday 01:45:00 PM,0
Monday 02:00:00 PM,0
Monday 02:15:00 PM,0
Monday 02:30:00 PM,0
Monday 02:45:00 PM,0
Monday 03:00:00 PM,0
Monday 03:15:00 PM,0
Monday 03:30:00 PM,0
Monday 03:45:00 PM,0
Monday 04:00:00 PM,0
Monday 04:15:00 PM,0
Monday 04:30:00 PM,0
Monday 04:45:00 PM,0
Tuesday 09:00:00 AM,0
Tuesday 09:15:00 AM,0
Tuesday 09:30:00 AM,0
Tuesday 09:45:00 AM,0
Tuesday 10:00:00 AM,1
Tuesday 10:15:00 AM,1
Tuesday 10:30:00 AM,1
Tuesday 10:45:00 AM,1
Tuesday 11:00:00 AM,1
Tuesday 11:15:00 AM,1
Tuesday 11:30:00 AM,0
Tuesday 11:45:00 AM,0
Tuesday 12:00:00 PM,0
Tuesday 12:15:00 PM,1
Tuesday 12:30:00 PM,1
Tuesday 12:45:00 PM,1
Tuesday 01:00:00 PM,1
Tuesday 01:15:00 PM,1
Tuesday 01:30:00 PM,1
Tuesday 01:45:00 PM,1
Tuesday 02:00:00 PM,0
Tuesday 02:15:00 PM,0
Tuesday 02:30:00 PM,0
Tuesday 02:45:00 PM,0
Tuesday 03:00:00 PM,0
Tuesday 03:15:00 PM,0
Tuesday 03:30:00 PM,0
Tuesday 03:45:00 PM,0
Tuesday 04:00:00 PM,0
Tuesday 04:15:00 PM,0
Tuesday 04:30:00 PM,0
Tuesday 04:45:00 PM,0
Wednesday 09:00:00 AM,0
Wednesday 09:15:00 AM,0
Wednesday 09:30:00 AM,0
Wednesday 09:45:00 AM,0
Wednesday 10:00:00 AM,0
Wednesday 10:15:00 AM,0
Wednesday 10:30:00 AM,0
Wednesday 10:45:00 AM,0
Wednesday 11:00:00 AM,0
Wednesday 11:15:00 AM,0
Wednesday 11:30:00 AM,0
Wednesday 11:45:00 AM,0
Wednesday 12:00:00 PM,0
Wednesday 12:15:00 PM,1
Wednesday 12:30:00 PM,1
Wednesday 12:45:00 PM,1
Wednesday 01:00:00 PM,1
Wednesday 01:15:00 PM,1
Wednesday 01:30:00 PM,1
Wednesday 01:45:00 PM,1
Wednesday 02:00:00 PM,0
Wednesday 02:15:00 PM,0
Wednesday 02:30:00 PM,0
Wednesday 02:45:00 PM,0
Wednesday 03:00:00 PM,0
Wednesday 03:15:00 PM,0
Wednesday 03:30:00 PM,0
Wednesday 03:45:00 PM,0
Wednesday 04:00:00 PM,0
Wednesday 04:15:00 PM,0
Wednesday 04:30:00 PM,0
Wednesday 04:45:00 PM,0
Thursday 09:00:00 AM,0
Thursday 09:15:00 AM,0
Thursday 09:30:00 AM,0
Thursday 09:45:00 AM,0
Thursday 10:00:00 AM,0
Thursday 10:15:00 AM,0
Thursday 10:30:00 AM,0
Thursday 10:45:00 AM,0
Thursday 11:00:00 AM,0
Thursday 11:15:00 AM,0
Thursday 11:30:00 AM,0
Thursday 11:45:00 AM,0
Thursday 12:00:00 PM,0
Thursday 12:15:00 PM,1
Thursday 12:30:00 PM,1
Thursday 12:45:00 PM,1
Thursday 01:00:00 PM,1
Thursday 01:15:00 PM,1
Thursday 01:30:00 PM,1
Thursday 01:45:00 PM,1
Thursday 02:00:00 PM,0
Thursday 02:15:00 PM,0
Thursday 02:30:00 PM,0
Thursday 02:45:00 PM,0
Thursday 03:00:00 PM,0
Thursday 03:15:00 PM,0
Thursday 03:30:00 PM,0
Thursday 03:45:00 PM,0
Thursday 04:00:00 PM,0
Thursday 04:15:00 PM,0
Thursday 04:30:00 PM,0
Thursday 04:45:00 PM,0
"""
	CSV.read(IOBuffer(s), DataFrame)
end

# ╔═╡ e3cca2c0-4c13-42d8-a7c9-ea6700683700
df_bob = let
	s = "Time,Avail
Monday 09:00:00 AM,0
Monday 09:15:00 AM,0
Monday 09:30:00 AM,0
Monday 09:45:00 AM,0
Monday 10:00:00 AM,1
Monday 10:15:00 AM,1
Monday 10:30:00 AM,1
Monday 10:45:00 AM,1
Monday 11:00:00 AM,1
Monday 11:15:00 AM,1
Monday 11:30:00 AM,1
Monday 11:45:00 AM,1
Monday 12:00:00 PM,1
Monday 12:15:00 PM,1
Monday 12:30:00 PM,1
Monday 12:45:00 PM,1
Monday 01:00:00 PM,1
Monday 01:15:00 PM,0
Monday 01:30:00 PM,0
Monday 01:45:00 PM,0
Monday 02:00:00 PM,0
Monday 02:15:00 PM,0
Monday 02:30:00 PM,0
Monday 02:45:00 PM,0
Monday 03:00:00 PM,0
Monday 03:15:00 PM,0
Monday 03:30:00 PM,0
Monday 03:45:00 PM,0
Monday 04:00:00 PM,0
Monday 04:15:00 PM,0
Monday 04:30:00 PM,0
Monday 04:45:00 PM,0
Tuesday 09:00:00 AM,0
Tuesday 09:15:00 AM,0
Tuesday 09:30:00 AM,0
Tuesday 09:45:00 AM,0
Tuesday 10:00:00 AM,0
Tuesday 10:15:00 AM,0
Tuesday 10:30:00 AM,0
Tuesday 10:45:00 AM,0
Tuesday 11:00:00 AM,0
Tuesday 11:15:00 AM,0
Tuesday 11:30:00 AM,0
Tuesday 11:45:00 AM,0
Tuesday 12:00:00 PM,0
Tuesday 12:15:00 PM,0
Tuesday 12:30:00 PM,0
Tuesday 12:45:00 PM,0
Tuesday 01:00:00 PM,0
Tuesday 01:15:00 PM,0
Tuesday 01:30:00 PM,0
Tuesday 01:45:00 PM,0
Tuesday 02:00:00 PM,0
Tuesday 02:15:00 PM,0
Tuesday 02:30:00 PM,0
Tuesday 02:45:00 PM,0
Tuesday 03:00:00 PM,0
Tuesday 03:15:00 PM,0
Tuesday 03:30:00 PM,0
Tuesday 03:45:00 PM,0
Tuesday 04:00:00 PM,0
Tuesday 04:15:00 PM,0
Tuesday 04:30:00 PM,0
Tuesday 04:45:00 PM,0
Wednesday 09:00:00 AM,0
Wednesday 09:15:00 AM,0
Wednesday 09:30:00 AM,0
Wednesday 09:45:00 AM,0
Wednesday 10:00:00 AM,0
Wednesday 10:15:00 AM,0
Wednesday 10:30:00 AM,0
Wednesday 10:45:00 AM,0
Wednesday 11:00:00 AM,0
Wednesday 11:15:00 AM,1
Wednesday 11:30:00 AM,1
Wednesday 11:45:00 AM,1
Wednesday 12:00:00 PM,1
Wednesday 12:15:00 PM,1
Wednesday 12:30:00 PM,1
Wednesday 12:45:00 PM,1
Wednesday 01:00:00 PM,1
Wednesday 01:15:00 PM,1
Wednesday 01:30:00 PM,1
Wednesday 01:45:00 PM,1
Wednesday 02:00:00 PM,1
Wednesday 02:15:00 PM,1
Wednesday 02:30:00 PM,1
Wednesday 02:45:00 PM,1
Wednesday 03:00:00 PM,1
Wednesday 03:15:00 PM,0
Wednesday 03:30:00 PM,0
Wednesday 03:45:00 PM,0
Wednesday 04:00:00 PM,0
Wednesday 04:15:00 PM,0
Wednesday 04:30:00 PM,0
Wednesday 04:45:00 PM,0
Thursday 09:00:00 AM,0
Thursday 09:15:00 AM,0
Thursday 09:30:00 AM,0
Thursday 09:45:00 AM,0
Thursday 10:00:00 AM,0
Thursday 10:15:00 AM,0
Thursday 10:30:00 AM,0
Thursday 10:45:00 AM,0
Thursday 11:00:00 AM,0
Thursday 11:15:00 AM,0
Thursday 11:30:00 AM,0
Thursday 11:45:00 AM,0
Thursday 12:00:00 PM,0
Thursday 12:15:00 PM,0
Thursday 12:30:00 PM,0
Thursday 12:45:00 PM,0
Thursday 01:00:00 PM,0
Thursday 01:15:00 PM,0
Thursday 01:30:00 PM,0
Thursday 01:45:00 PM,0
Thursday 02:00:00 PM,0
Thursday 02:15:00 PM,0
Thursday 02:30:00 PM,0
Thursday 02:45:00 PM,0
Thursday 03:00:00 PM,0
Thursday 03:15:00 PM,0
Thursday 03:30:00 PM,0
Thursday 03:45:00 PM,0
Thursday 04:00:00 PM,0
Thursday 04:15:00 PM,0
Thursday 04:30:00 PM,0
Thursday 04:45:00 PM,0"
	CSV.read(IOBuffer(s), DataFrame)
end

# ╔═╡ b32ecd15-75f2-4e8f-ae5f-de6f3b15a03e
leftjoin(df_ian, df_bob; on=[:Time, :Avail])

# ╔═╡ bdb1b78c-603c-4f16-8ed3-51ca448c1233
md"""
Courtesy of the [discusson here](https://gist.github.com/camtheman256/3125e18ba20e90b6252678714e5102fd)
"""

# ╔═╡ becd3ac2-97c7-11ed-0de5-7793d9986316
md"""
```javascript
function getCSV() {
  result = "Time," + PeopleNames.join(",")+"\n"; 
  for(let i = 0; i < AvailableAtSlot.length; i++) {
      let slot = $x(`string(//div[@id="GroupTime${TimeOfSlot[i]}"]/@onmouseover)`);
      slot = slot.match(/.*"(.*)".*/)[1];
      result += slot + ",";
      result += PeopleIDs.map(id => AvailableAtSlot[i].includes(id) ? 1 : 0).join(",");
      result+= "\n";
  }
  console.log(result);
}
getCSV();
```
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
MarkdownLiteral = "736d6165-7244-6769-4267-6b50796e6954"

[compat]
CSV = "~0.10.9"
DataFrames = "~1.4.4"
MarkdownLiteral = "~0.1.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "a64a90d54b56574866739496db1652a4c34a0be6"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "SnoopPrecompile", "Tables", "Unicode", "WeakRefStrings", "WorkerUtilities"]
git-tree-sha1 = "c700cce799b51c9045473de751e9319bdd1c6e94"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.9"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "SnoopPrecompile", "URIs"]
git-tree-sha1 = "483cb3fb9c159226e9f61d66a32fb3c8bf34e503"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.9"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d4f69885afa5e6149d0cab3818491565cf41446d"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.4.4"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "e27c4ebe80e8699540f2d6c805cc12203b614f12"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.20"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "0cf92ec945125946352f3d46c96976ab972bde6f"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.3.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InvertedIndices]]
git-tree-sha1 = "82aec7a3dd64f4d9584659dc0b62ef7db2ef3e19"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.2.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MarkdownLiteral]]
deps = ["CommonMark", "HypertextLiteral"]
git-tree-sha1 = "0d3fa2dd374934b62ee16a4721fe68c418b92899"
uuid = "736d6165-7244-6769-4267-6b50796e6954"
version = "0.1.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "8175fc2b118a3755113c8e68084dc1a9e63c61ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.3"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "96f6db03ab535bdb901300f88335257b0018689d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.2"

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

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "c02bd3c9c3fc8463d3591a62a378f90d2d8ab0f3"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.17"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

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

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.WorkerUtilities]]
git-tree-sha1 = "cd1659ba0d57b71a464a29e64dbc67cfe83d54e7"
uuid = "76eceee3-57b5-4d4a-8e66-0e911cebbf60"
version = "1.6.1"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"
"""

# ╔═╡ Cell order:
# ╟─14083450-7c1a-4483-aa26-75a793576eb4
# ╟─e3cca2c0-4c13-42d8-a7c9-ea6700683700
# ╠═b32ecd15-75f2-4e8f-ae5f-de6f3b15a03e
# ╟─bdb1b78c-603c-4f16-8ed3-51ca448c1233
# ╟─becd3ac2-97c7-11ed-0de5-7793d9986316
# ╠═b653343f-97ad-4367-b604-c734c957a2a7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
