using Random
using StaticArrays

struct CounterState
    n::Int32
    counters::SVector{20,Int64}
end

const DENYLIST = Set{String}(["BF", "BK", "BW", "BX", "CV", "CW", "CX", "DK",
    "DX", "FB", "FD", "FH", "FK", "FN", "FP", "FQ", "FV", "FW", "FX", "GB",
    "GC", "GK", "GP", "GV", "GX", "HG", "HK", "HV", "HX", "KC", "KK", "KV",
    "KX", "LX", "MK", "MV", "MX", "PG", "PV", "PX", "SX", "TK", "TX", "VB",
    "VC", "VD", "VF", "VG", "VH", "VK", "VL", "VM", "VN", "VP", "VT", "VV",
    "VW", "VX", "WG", "WV", "WW", "WX", "XB", "XD", "XG", "XK", "XM", "XN",
    "XR", "XS", "XW", "YK", "YW", "YX", "YY"
])
const ALLOWLIST = Set{String}([
    "TH", "HE", "IN", "ER", "AN", "RE", "AT", "ON", "ND", "EN", "ES"])

const COMMON_WORDS = Set{String}([
    "THE", "BE", "AND", "OF", "HAVE", "THAT", "FOR", "YOU", "WITH", "THIS", "THEY"
])

function dynamic_microcosm_hash(lines::Vector{Int64}, state::CounterState)
    pagenum = length(lines) + 1
    page_lines = BOOK[pagenum]
    counters = allocate_counters()
    @time for (i, line) = collect(enumerate(page_lines))
        copy!(counters, state.counters)
        n = state.n

        for c in line
            @inbounds counters[n] += c
            if n == 20
                n = 1
            else
                n += 1
            end
        end
        if pagenum < 14
            dynamic_microcosm_hash(cat(lines, [i], dims=1), CounterState(n, counters))
        else
            char_dict = Dict{Char,Int}()
            bigrams = Set{String}()
            prevchar::Char = ' '
            function mod(x)
                int_val = (x % 26) + 64
                charval = Char(int_val == 64 ? ' ' : int_val)

                get!(char_dict, charval, 0)
                @inbounds char_dict[charval] += 1
                if prevchar != ' ' && charval != ' '
                    push!(bigrams, prevchar * charval)
                end
                prevchar = charval
                return charval
            end
            strval = rstrip(String(mod.(counters)))
            entropy = 0.0
            for (c, count) in char_dict
                frequency = count / 20
                entropy -= frequency * (log(frequency) / log(2))
            end

            goodsignals = length(intersect(bigrams, ALLOWLIST))
            badsignals = length(intersect(bigrams, DENYLIST))

            words = split(strval, ' ')
            for word = words
                if length(word) == 1
                    if word == "A" || word == "I"
                        goodsignals += 1
                    else
                        badsignals += 1
                    end
                elseif word in COMMON_WORDS
                    goodsignals += 1
                end
            end


            # if (strval[1] != ' '
            #     && !contains(strval, "  ")
            #     && get(char_dict, 'Q', 0) < 1
            #     && get(char_dict, 'J', 0) < 1
            #     && get(char_dict, ' ', 0) > 2
            #     && badsignals < 2
            #     && goodsignals >= 3
            #     && (goodsignals - badsignals > 3)
            #    ) || contains(strval, "WASHINGTON") || contains(strval, "GASHTAN")
            println(cat(lines, [i], dims=1), " ", strval, " ", entropy, " ", goodsignals, " ", badsignals)
            # end
        end
    end
end

function allocate_counters()
    return zeros(MVector{20,Int64})
end

function microcosm_hash(lines::Vector{String})
    m_array::Vector{Int64} = zeros(20)
    n = 1
    for line in lines
        for c in line
            m_array[n] += c
            if n == 20
                n = 1
            else
                n += 1
            end
        end
        function mod(x)
            int_val = (x % 26) + 64
            return int_val == 64 ? ' ' : int_val
        end
        return String(Char.(mod.(m_array)))
    end
end
