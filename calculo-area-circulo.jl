### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 26b4253f-7d15-47f4-af13-398a421c76f2
using SymPy, PlutoUI

# ╔═╡ 03c7ad73-e71e-4df4-9ebc-a4a5b16acd0a
md"""
# Cálculo científico con Julia 🧪

!!! question "¿Qué es Julia?"
	Julia es un moderno lenguaje de programación especialmente diseñado para el cálculo científico que destaca principalmente en la construcción de modelos matemáticos.
"""

# ╔═╡ 4eb49696-55c7-47d1-bb13-5ef79885b5c2
md"""
## Cálculo del perímetro y del área de un círculo

En este taller veremos como utilizar el **método de agotamiento** para aproximar el perímetro y el área de un círculo con Julia.
"""

# ╔═╡ 1534b360-a534-11ef-3907-85c979017697
md"""

!!! info "Método de agotamiento"
	En el siglo III A.C [Arquímedes](https://es.wikipedia.org/wiki/Arqu%C3%ADmedes) usó el [método por agotamiento](https://es.wikipedia.org/wiki/M%C3%A9todo_por_agotamiento) para calcular el área encerrada por una circunferencia (y de paso el valor de $\pi$). La idea consiste en inscribir en la circunferencia polígonos regulares con un número de lados cada vez mayor.
	
	![Polígonos regulares inscritos en la circunferencia](https://aprendeconalf.es/analisis-practicas-julia/img/sucesiones/poligonos-circunferencia.png)

"""

# ╔═╡ 1aaea6d1-ce01-413b-b2f9-6885ba5a6196
md"""
## Cálculo del perímetro de los polígonos inscritos

El perímetro de estos polígonos puede calcularse fácilmente descomponiendo los polígonos regulares en triángulos como en el siguiente ejemplo.

![Descomponsición de un polígono en triángulos](https://aprendeconalf.es/analisis-practicas-julia/img/sucesiones/area-poligono-regular-inscrito.png)
"""

# ╔═╡ 3f6ba26a-3523-467a-ba21-3f24f42fb39c
md"""
!!! question "¿Cuál es la base de cada uno de estos triángulos?"
"""

# ╔═╡ 07e9f020-efb7-46fc-8751-a311fdd1d034
begin
sol1 = @bind solucion1 CheckBox()
	md"**MOSTRAR SOLUCIÓN** $sol1"
end

# ╔═╡ 86aa5956-7846-41c9-8b8f-b650eeff5463
if solucion1 
	md"""
	La base es 
	
	$$2r\operatorname{sen}\left(\frac{\pi}{n}\right)$$.
	"""
end

# ╔═╡ add499af-fd3e-43e2-94fb-28e5ebd30107
md"""
!!! question "¿Cuál es el área de cada uno de estos triángulos?"
"""

# ╔═╡ c2dc61df-173e-4c95-8875-35b324a1fb24
begin
sol2 = @bind solucion2 CheckBox()
	md"**MOSTRAR SOLUCIÓN** $sol2"
end

# ╔═╡ 7d16979a-d188-450b-b952-2595c02d39e8
if solucion2
	md"""
	El área es 
	
	$$\frac{1}{2}2r\operatorname{sen}\left(\frac{\pi}{n}\right)r\cos\left(\frac{\pi}{n}\right) = \frac{1}{2}r^2\operatorname{sen}\left(\frac{2\pi}{n}\right).$$
	"""
end

# ╔═╡ 075def84-f8fb-4bd0-a431-8911a3ae1119
md"""
## Aproximación del perímetro y del área de la circunferencia

Usando las fórmulas anteriores podemos definir una función en Julia para calcular el el perímetro y otra para el área de un polígono regular de $n$ lados. Para simplificar, tomaremos un círculo de radio $r=1$.
"""

# ╔═╡ 4dcaef0c-b003-4ef3-afb3-7d1b3220e747
p(n) = 2n * sin(PI/n)

# ╔═╡ cf8c210a-5cc1-43fb-8557-9f0ed61535dd
a(n) = n * sin(2*PI/n) / 2

# ╔═╡ b8e6acb3-b3b0-4f1d-af2e-f21787c3b17f
begin
lados = @bind n Slider(3:100, show_value=true)
md"""Número de lados $lados"""
end

# ╔═╡ f9af3965-b7dc-4cd2-8665-18bb0953ce4d
md"""
Perímetro = $(float(p(n)))

Área = $(float(a(n)))
"""

# ╔═╡ 9781c76f-8125-43a5-b26c-4f0867e51e41
md"""
!!! question "¿Hacia qué valor tiende el perímetro? ¿Y el área?"
"""

# ╔═╡ 4e0cedb1-3f37-41a1-98a0-207a79277380
md"""
## Cálculo del límite

Parece evidente que el perímetro de la circunferencia aparecerá en el límite cuando el número de lados tiende a infinito del perímetro del polígono de $n$ lados. Y lo mismo ocurre con el área.

En Julia podemos calcular límites con la función `limit` del paquete `SymPy`.
"""

# ╔═╡ 37d2724f-eade-4cf2-9e9c-9c87f42ee5fb
begin
@syms x
perimetro = limit(p(x), x=>oo)
area = limit(a(x), x=>oo)
md"""
Límite del perímetro: 
``\lim_{n\to\infty} n\operatorname{sen}\left(\frac{\pi}{n}\right) =`` $perimetro

Límite del área: 
``\lim_{n\to\infty} \frac{1}{2}n\operatorname{sen}\left(\frac{2\pi}{n}\right) =`` $area
"""
end

# ╔═╡ 43220735-9069-4ac1-94a6-2faf42f80aaa
md"""
!!! warning "!Enhorabuena!"

	Ahora ya sabes cómo los antiguos griegos fueron capaces de obtener una buena aproximación del número $\pi$ usando este ingenioso método.
"""

# ╔═╡ 1243aac7-ba90-4c8d-8c61-77bc8e4b6b8b
pista(texto) = Markdown.MD(Markdown.Admonition("hint", "Pista", [texto]));

# ╔═╡ 98b1b285-405c-4e56-a2d2-3d420e7d99b1
pista(md"""Dividiendo el ángulo $\alpha$ por la mitad se obtienen triángulos rectángulos cuyo cateto opuesto es la mitad de la base del triángulo original.""")

# ╔═╡ 6ffee859-06dc-45b2-b972-14ed6e6a09ea
pista(md"""Dividiendo el ángulo $\alpha$ por la mitad se obtienen triángulos rectángulos cuyo cateto contiguo es la altura del triángulo original.""")

# ╔═╡ fb49178f-9211-4962-a11a-cd5b419e56f5
correcto(text) = Markdown.MD(Markdown.Admonition("correct", "¡Correcto!", [text]));

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SymPy = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"

[compat]
PlutoUI = "~0.7.60"
SymPy = "~2.2.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.1"
manifest_format = "2.0"
project_hash = "a2c64bfed4dde85da11085ba390e2a8a9ed64ae1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CommonEq]]
git-tree-sha1 = "6b0f0354b8eb954cdba708fb262ef00ee7274468"
uuid = "3709ef60-1bee-4518-9f2f-acd86f176c50"
version = "0.2.1"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "b19db3927f0db4151cb86d073689f2428e524576"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.10.2"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "be3dc50a92e5a386872a493a10050136d4703f9b"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.6.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "ce5f5621cac23a86011836badfedf664a612cee4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.5"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "a2d09619db4e765091ee5c6ffe8872849de0feea"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.28"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+2"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "dfdf5519f235516220579f949664f1bf44e741c5"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.6.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "9816a3826b0ebf49ab4926e2b18842ad8b5c8f04"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.96.4"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "2f5d4697f21388cbe1ff299430dd169ef97d7e14"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.4.0"

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

    [deps.SpecialFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SymPy]]
deps = ["CommonEq", "CommonSolve", "LinearAlgebra", "PyCall", "SpecialFunctions", "SymPyCore"]
git-tree-sha1 = "d35b297be048dfac05bcff29e55d6106808e3c5a"
uuid = "24249f21-da20-56a4-8eb1-6a02cf4ae2e6"
version = "2.2.0"

[[deps.SymPyCore]]
deps = ["CommonEq", "CommonSolve", "Latexify", "LinearAlgebra", "Markdown", "RecipesBase", "SpecialFunctions"]
git-tree-sha1 = "bef92ec4c31804bdc9c44cb00eaf0348eac383fb"
uuid = "458b697b-88f0-4a86-b56b-78b75cfb3531"
version = "0.2.5"

    [deps.SymPyCore.extensions]
    SymPyCoreTermInterfaceExt = "TermInterface"

    [deps.SymPyCore.weakdeps]
    TermInterface = "8ea1fca8-c5ef-4a55-8b96-4e9afe9c9a3c"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─03c7ad73-e71e-4df4-9ebc-a4a5b16acd0a
# ╟─4eb49696-55c7-47d1-bb13-5ef79885b5c2
# ╟─1534b360-a534-11ef-3907-85c979017697
# ╟─1aaea6d1-ce01-413b-b2f9-6885ba5a6196
# ╟─3f6ba26a-3523-467a-ba21-3f24f42fb39c
# ╟─98b1b285-405c-4e56-a2d2-3d420e7d99b1
# ╟─07e9f020-efb7-46fc-8751-a311fdd1d034
# ╟─86aa5956-7846-41c9-8b8f-b650eeff5463
# ╟─add499af-fd3e-43e2-94fb-28e5ebd30107
# ╟─6ffee859-06dc-45b2-b972-14ed6e6a09ea
# ╟─c2dc61df-173e-4c95-8875-35b324a1fb24
# ╟─7d16979a-d188-450b-b952-2595c02d39e8
# ╟─075def84-f8fb-4bd0-a431-8911a3ae1119
# ╠═4dcaef0c-b003-4ef3-afb3-7d1b3220e747
# ╠═cf8c210a-5cc1-43fb-8557-9f0ed61535dd
# ╟─b8e6acb3-b3b0-4f1d-af2e-f21787c3b17f
# ╟─f9af3965-b7dc-4cd2-8665-18bb0953ce4d
# ╟─9781c76f-8125-43a5-b26c-4f0867e51e41
# ╟─4e0cedb1-3f37-41a1-98a0-207a79277380
# ╟─37d2724f-eade-4cf2-9e9c-9c87f42ee5fb
# ╟─43220735-9069-4ac1-94a6-2faf42f80aaa
# ╠═26b4253f-7d15-47f4-af13-398a421c76f2
# ╟─1243aac7-ba90-4c8d-8c61-77bc8e4b6b8b
# ╟─fb49178f-9211-4962-a11a-cd5b419e56f5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
