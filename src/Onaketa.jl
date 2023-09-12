module Onaketa

using MarkdownLiteral: @mdx

export download_schedules, extract_times, get_matches, plot_matches, @mdx

include("matching.jl")

end
