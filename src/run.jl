include("book.jl")
include("algorithm.jl")

using StaticArrays


# messages = [
#     "IN THE LAND OF THE DRAGON",
#     "EXCHANGE OF APPLES",
#     "A MESSAGE FROM JUPITER",
#     "A PEANUT FOR SEMELIA",
#     "A COMMODORE AT TRAFALGAR",
#     "APRICOTS AND NECTARINES",
#     "THE GENIE IN THE CHURCH",
#     "SHARP DAGGERS CONCEALED",
#     "EMPEROR WANG MOURNS",
#     "HE CARRIES THE TORCH",
#     "THE VICTOR REJOICES",
#     "A FORTUNE IS LOST",
#     "A PET TAKES FLIGHT",
#     "TFRQAMYUWOLXKTDNBHIW",
# ]
# print(microcosm_hash(messages), '\n')

function run_thread()
    dynamic_microcosm_hash(Vector{Int64}(undef, 0), CounterState(1, zeros(MVector{20,Int64})))
end

Threads.@threads for i = 1:Threads.nthreads()
    run_thread()
end