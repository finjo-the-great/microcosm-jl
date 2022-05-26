
function microcosm_hash(lines::Vector{String})
    m_array = Vector{Int32}(undef, 20)
    n = 1
    for line in lines, c in line
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

messages = [
    "IN THE LAND OF THE DRAGON",
    "EXCHANGE OF APPLES",
    "A MESSAGE FROM JUPITER",
    "A PEANUT FOR SEMELIA",
    "A COMMODORE AT TRAFALGAR",
    "APRICOTS AND NECTARINES",
    "THE GENIE IN THE CHURCH",
    "SHARP DAGGERS CONCEALED",
    "EMPEROR WANG MOURNS",
    "HE CARRIES THE TORCH",
    "THE VICTOR REJOICES",
    "A FORTUNE IS LOST",
    "A PET TAKES FLIGHT",
    "TFRQAMYUWOLXKTDNBHIW",
]
print(microcosm_hash(messages), '\n')