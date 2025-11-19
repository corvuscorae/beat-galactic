local init = require("assets.songs._init")

local ext = ".mp3"
local path = "/assets/songs/"
init.initFiles(ext, false)

local tags = {
    As_Long_as_I_ve_Got_You = {
        TIME = {"1967"},
        GENRE = {"RnB", "soul pop", "doo wop", "soul"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"oldies", "ballads"},
        VIBES = {"chill", "happy", "easy", "love"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "drums", "no_drums_full"},
            BPM = "86",
            KEY = "Fsharp/Gflat",
            TIME_SIG = "4/4"
        }
    },
    At_Last = {
        TIME = {"1960"},
        GENRE = {"RnB", "soul", "jazz", "blues"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"oldies", "ballads"},
        VIBES = {"easy", "happy", "love", "iconic"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "no_drums_full"},
            BPM = "87",
            KEY = "F",
            TIME_SIG = "3/4"
        }
    },
    Bodyguard = {
        TIME = {"2024"},
        GENRE = {"pop", "country", "soft rock"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"contemporary"},
        VIBES = {"love", "dance"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "drums", "no_drums_full"},
            BPM = "119",
            KEY = "E",
            TIME_SIG = "4/4"
        }
    },
    Bring_It_On_Home_to_Me = {
        TIME = {"1963"},
        GENRE = {"RnB", "soul"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"oldies"},
        VIBES = {"sway", "love", "easy"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "no_drums_full"},
            BPM = "71",
            KEY = "C",
            TIME_SIG = "4/4"
        }
    },
    HOOD = {
        TIME = {"2024"},
        GENRE = {"hip hop", "punk"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {},
        VIBES = {"hardcore", "dance"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals"},
            BPM = "169",
            KEY = "A",
            TIME_SIG = "4/4"
        }
    },
    Hoyt_And_Schermerhorn = {
        TIME = {"2018"},
        GENRE = {"rap"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {},
        VIBES = {"love", "happy"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "drums", "no_drums_full"},
            BPM = "170",
            KEY = "Cshard/Dflat",
            TIME_SIG = "4/4"
        }
    },
    LOVE = {
        TIME = {"2017"},
        GENRE = {"rap", "hip hop", "RnB"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"contemporary"},
        VIBES = {"sway", "chill", "love"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "drums", "no_drums_full"},
            BPM = "126",
            KEY = "Asharp/Bflat",
            TIME_SIG = "4/4"
        }
    },
    Lets_Stay_Together = {
        TIME = {"1972"},
        GENRE = {"RnB", "soul", "soul pop"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"oldies"},
        VIBES = {"happy", "love", "chill", "easy"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "drums", "no_drums_full"},
            BPM = "102",
            KEY = "G",
            TIME_SIG = "4/4"
        }
    },
    Loud = {
        TIME = {"2020"},
        GENRE = {"pop", "indie"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"deep cuts"},
        VIBES = {"sexy"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "drums", "no_drums_full"},
            BPM = "121",
            KEY = "E",
            TIME_SIG = "4/4"
        }
    },
    Low_Rider = {
        TIME = {"1975"},
        GENRE = {"funk", "funk rock"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"classics"},
        VIBES = {"stoner", "happy", "easy", "iconic"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "drums", "no_drums_full"},
            BPM = "140",
            KEY = "C",
            TIME_SIG = "4/4"
        }
    },
    Sittin_On_the_Dock_of_the_Bay = {
        TIME = {"1967"},
        GENRE = {"soul", "RnB"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"oldies"},
        VIBES = {"chill", "iconic", "sad"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "drums", "no_drums_full"},
            BPM = "104",
            KEY = "D",
            TIME_SIG = "4/4"
        }
    },
    Starburster = {
        TIME = {"2024"},
        GENRE = {"indie"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {},
        VIBES = {},
        METRICS = { 
            SPLITS = {"instrumental", "vocals"},
            BPM = "98",
            KEY = "Asharp/Bminor",
            TIME_SIG = "4/4"
        }
    },
    Stranger_At_My_Door = {
        TIME = {"1967"},
        GENRE = {"RnB", "soul"},
        LOCALE = {},
        --GENREMOD = {},
        SPECIAL = {"oldies"},
        VIBES = {"sad", "breakup"},
        METRICS = { 
            SPLITS = {"instrumental", "vocals", "no_drums_full"},
            BPM = "92",
            KEY = "C",
            TIME_SIG = "4/4"
        }
    }
}

return {
    tags = tags, 
    ext = ext, 
    path = path
}
