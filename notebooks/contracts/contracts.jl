### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 70bfa856-99fb-11ee-012b-8b2e755cc541
using Tectonic

# ╔═╡ 6197a49c-e09c-4e4b-86d7-2644cd084d06
contract = raw"""
\documentclass{article}
\usepackage[T1]{fontenc}
\usepackage[margin=2cm]{geometry}
\usepackage[parfill]{parskip}
\usepackage{
    charter,
    graphicx,
    hyperref,
    xcolor,
    fancyhdr,
    enumitem,
}

% Form field
\definecolor{onaketa-pink}{HTML}{ec008c}
\def\DefaultOptionsofText{
    borderstyle = U,
    bordercolor = black,
    backgroundcolor = {},
    align = 0,
}

% Header/footer
\pagestyle{fancy}
\fancyhead[L]{\textcolor{onaketa-pink}{\Large{Agreement between student* and tutor-mentor}} \\ \normalsize \textit{*If the student is a minor, a guardian must also sign this document.}}
\fancyhead[R]{\includegraphics{logo.png}}
\setlength{\headheight}{36pt}
\fancyfoot{}

% Global
\setlength{\parindent}{0pt}
\setlist[1]{itemsep=-0.125ex}

\begin{document}
This document represents an agreement between tutor-mentor and program participant(s) regarding their working relationship.

\begin{center}
***
\end{center}

\subsubsection*{Frequency of meetings}
Regular one-on-one meetings will be held at least once a week over the semester. During the first or second session, students/guardians and tutor-mentors should come to a mutual agreement on their final session of the semester.

\textit{Holidays} -- If the tutor-mentoring session falls on a national holiday, that session will be postponed or canceled. The student and/or guardian and tutor-mentor will take the initiative to either reschedule the session for the same week, or cancel it entirely.

\subsubsection*{Expectations of the student}
As the student, I will do my best to:
\begin{itemize}
\item Show up on time to my tutor-mentoring sessions.
\item Provide my tutor-mentor with class materials that will help them to help me (e.g., syllabus, homework assignments, name of textbook).
\item Come to each session prepared to participate in my learning.
\item Be courteous and respectful to my tutor-mentor.
\item Keep my video turned on during our virtual sessions, whenever possible.
\end{itemize}

\subsubsection*{Expectations of the tutor-mentor}
As the tutor-mentor, I will always:

\begin{itemize}
\item Be kind, courteous, and respectful to my student.
\item Do my best to help the student excel in their class and reach their academic goals.
\item Show up on time to our sessions. If I am running late to a session due to unforeseen circumstances, I will contact the student and/or guardian as soon as possible.
\item If I have to miss a tutor-mentoring session, I will contact the student and/or guardian at least 24 hours in advance. If possible, I will either (1) reschedule for a different time during that same week or (2) find a substitute tutor-mentor.
\end{itemize}

\subsubsection*{Canceled sessions \& absences}
\begin{itemize}
\item If the student needs to cancel or reschedule a session, it is the responsibility of the student or guardian to inform the tutor-mentor at least 24 hours before that next session.
\item If the student misses a session without telling their tutor-mentor ahead of time, this will count as an absence.
\item If a student misses three sessions during a semester, they will be asked to leave the Onaketa program for that semester. This is necessary so that our tutor-mentors can be available to help other students who show up consistently. 
\end{itemize}

\subsubsection*{Continuation beyond the first semester}
Continuation with Onaketa for the coming semester will be contingent upon good attendance and good standing during the previous semester.

\subsubsection*{Acknowledgement}
I acknowledge with my signature typed below that I have read this document and understand the expectations of me.

\vspace*{1.5cm}

\begin{tabular}{ll}
\makebox[0.5\textwidth]{\TextField[width=0.5\textwidth]{}} & \makebox[0.3\textwidth]{\TextField[width=0.3\textwidth]{}}\\
Student & Date\\[8ex]
\makebox[0.5\textwidth]{\TextField[width=0.5\textwidth]{}} & \makebox[0.3\textwidth]{\TextField[width=0.3\textwidth]{}}\\
Guardian & Date\\[8ex]
\makebox[0.5\textwidth]{\TextField[width=0.5\textwidth]{}} & \makebox[0.3\textwidth]{\TextField[width=0.3\textwidth]{}}\\
Tutor-mentor & Date
\end{tabular}

\end{document}
"""

# ╔═╡ e67c0f52-5f98-4855-bc72-c01dd461b2ee
tectonic() do bin
	write("src/contract.tex", contract)
	run(`$(bin) -o pdfs src/contract.tex`)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Tectonic = "9ac5f52a-99c6-489f-af81-462ef484790f"

[compat]
Tectonic = "~0.8.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "964cc42addaacc4fd8df651c82f6c39bee6e7a51"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Tectonic]]
deps = ["Pkg"]
git-tree-sha1 = "0b3881685ddb3ab066159b2ce294dc54fcf3b9ee"
uuid = "9ac5f52a-99c6-489f-af81-462ef484790f"
version = "0.8.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═70bfa856-99fb-11ee-012b-8b2e755cc541
# ╟─6197a49c-e09c-4e4b-86d7-2644cd084d06
# ╠═e67c0f52-5f98-4855-bc72-c01dd461b2ee
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
