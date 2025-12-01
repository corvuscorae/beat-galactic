local init = require("assets.songs._init")

local ext = ".mp3"
local applepath = "/assets/songs/"
local subfolders = {"drums", "main", "padding", "texture"}
local log_names = false

local paths = init.initFiles(applepath, subfolders, ext, log_names)

local tags = {
    drums = {
        _102 = {
            x = {
                bikermice_drums = {},
                bulverk_drums = {},
                calvin_harris_x_the_weeknd_drum_loop_001 = {},
                drumhalo = {},
                funky = {},
                kendrick_lamar_drums_102bpm = {},
                mustard_breakcore_drum = {}
            }
        },
        _104 = {
            x = {
                afrobeat_drumloop_bolutife_anifowose = {},
                aggressive_fast_trap_drums_with_808 = {},
                boom_bap_ish_drums = {},
                daft_punk = {},
                drum_loop_14 = {},
                monsieur_samba_percussion_loop_bpm = {},
                simple_hip_hop_rap_type_drum_beat_lasting = {},
                simple_hip_hop_rap_type_drum_beat_lasting_1 = {}
            }
        },
        _119 = {
            x = {
                jackboys_type_drums_2 = {},
                sakpase_drums = {},
                to_have_you_back_afrobeat_drum_loop_bpm = {}
            }
        },
        _121 = {
            x = {
                hip_hop_drum_loop = {},
                melodic_trap_drums = {},
                old_school_drum_loop = {},
                pop_rap_type_drum_loop_bpm = {},
                rap_type_drum_loop_frogless = {},
                swing_drums = {}
            }
        },
        _126 = {
            x = {
                astro_house_drums_126bpm_with_kick = {},
                bass_house_drums_kitcheny = {},
                elechouse_drums_128 = {},
                futuristic_drum_loop_2 = {},
                hard_edm_house_drum_loop_with_hats_part_2 = {},
                house_drums_slppped = {},
                malikmanley_untitled_drum_n_arp = {},
                zave_x_jonas_aden_drums = {}
            }
        },
        _140 = {
            x = {
                agressive_type_drum = {},
                crank_that_type_steel_drum = {},
                drum_loop_140bpm = {},
                heavy_metal_type_drum_loop_4 = {},
                jerk_sexy_drill_hoodtrap_drumloop = {},
                necrotrap_drum = {},
                travis_scott_x_ken_carson_type_drums = {}
            }
        },
        _169 = {
            x = {
                fq_em_up_drums = {},
                hard_bouncy_drums = {},
                hard_trap_drums = {},
                hard_trap_freestyle_drum_loop_part_169bpm = {},
                looperman_l_5610982_0398923_hard_trap_freestyle_drum_loop_part_2_169bpm = {},
                pierre_bourne_type_drums = {}
            }
        },
        _170 = {
            x = {
                drum_loop = {},
                drum_loop_bpm_hiphop = {},
                happy_hardcore_drums_deep_fried = {},
                hardtekk_drums = {},
                phonk_drum_pattern_with_fucked_808 = {},
                realistic_dnb_drums = {},
                strangers_punk_pop_drums = {},
                unique_trap_drums_w_perc_kick_and_snare_roll = {}
            }
        },
        _71 = {
            x = {
                fidle_lofi_drums = {},
                killer_drums_7 = {},
                lo_fi_drums = {},
                royal_rumble = {}
            }
        },
        _86 = {
            x = {
                boom_bap_drum = {},
                classic_boom_bap_drum_bpm = {},
                drum_type_odeal_x_brent_faiyaz = {},
                hip_hop_mobb_drum_beat_bpm = {},
                skipit_drums = {},
                turbo_boombap_drums = {}
            }
        },
        _87 = {
            x = {
                armatron_drums = {},
                boom_bap_drum_bpm_hd = {},
                boombap_drums = {},
                boombap_drums_1 = {},
                dark_drums_hip_hop_90s_with_intense_bpm = {},
                modern_reggaeton_loop_erlin_urbano_2 = {},
                something_drums_hard_idk = {},
                timid_drumz = {}
            }
        },
        _92 = {
            x = {
                boom_bap_drum_loop = {},
                cali_808 = {},
                jerk_hoodtrap_drum_92bpm = {},
                old_school_gang_starr_style_loop = {},
                reggaeton_latin_drums = {},
                slime_drums = {}
            }
        },
        _98 = {
            x = {
                bands_in_my_hands_post_malone_sunflower_drums = {},
                hyphy_drums_bay_area_ralfy_famous_dave_west_coast = {},
                modern_reggaeton_loop_erlin_urbano_1 = {},
                old_school_hip_hop_type_drum_loop_spazzin_out = {},
                trapsoul_x_rnb_type_drum_loop_001 = {}
            }
        }
    },
    main = {
        _102 = {
            D = {
                nba_youngboy_type_full_piano = {},
                piano_ride_102 = {},
                waltz_time_synth = {}
            },
            G = {
                asake_x_rema_inspired_loop = {},
                rock_guitar_i_dont_care_yungblud_type_guitar = {}
            }
        },
        _104 = {
            D = {
                axit_guitars = {},
                the_price_is_right_trap_rap_guitar_part_2 = {}
            },
            G = {
                groovy_thing_piano = {},
                soulful_pianissimo = {}
            }
        },
        _119 = {
            E = {
                bright_soul_horns_riff = {},
                living_feeling_empty_sad_depressed_guitar_melody = {},
                mxpaa_house_starter_piano = {},
                mxpaaa_house_starter_piano_pt2 = {},
                self_made_sad_guitar_melody = {},
                tmanpro_catches_your_eyes_bpm = {}
            }
        },
        _121 = {
            E = {
                alternative_rock = {},
                hang_asian_idk = {}
            }
        },
        _126 = {
            Dsharp = {
                shock_arp_melody = {}
            },
            F = {
                dark_piano_riff_1 = {},
                sahbabii_x_pierre_bourne_x_lancey_foux = {}
            }
        },
        _140 = {
            C = {
                dunelead = {},
                edm_loop = {},
                virus_trance_lead = {}
            }
        },
        _169 = {
            D = {
                playa = {}
            },
            E = {
                pop_punk_type_guitar_stars_pt1 = {}
            },
            Fsharp_m = {
                chaos = {},
                nick_mira_x_juice_wrld_type_melody = {},
                wooden_flute_169 = {}
            }
        },
        _170 = {
            Csharp = {
                juice_wrld_x_lil_uzi_vert_feeling = {}
            }
        },
        _71 = {
            Am = {
                lofi_guitar = {}
            },
            C = {
                german_carnival_synth = {},
                sad_piano_pure_virtual_swag = {}
            }
        },
        _86 = {
            B = {
                nostalgic_ambient_guitar_pt1 = {}
            },
            Fsharp = {
                blrd_color_no_time_strong_bells = {},
                sad_piano_i_am_with_you = {}
            }
        },
        _87 = {
            F = {
                danke_factory = {},
                glow_synth_loop = {},
                rasputin60s_ballad_guitar_strums = {},
                sushilbawa_adventure_tone_87 = {}
            }
        },
        _92 = {
            C = {
                lo_fi_flute = {},
                october_mood_synth_of_2 = {},
                organ_melody = {},
                vibey_african_guitar = {}
            }
        },
        _98 = {
            Dsharp = {
                come_up_strings = {},
                freesampleguy_tropical_house_chords_bpm_d_sharp = {},
                hellion_juice_wrld_x_iann_dior_guitar = {}
            },
            Gm = {
                goodbye_jhayco_x_alejo_synth_lead = {}
            }
        }
    },
    padding = {
        _102 = {
            C = {
                chopped_synth = {}
            },
            G = {
                e_u_synthy_choir = {},
                tyga_x_da_domain_vocals_chops = {}
            }
        },
        _104 = {
            D = {
                hbsamples_hbs_inferno_choir_da104bpm = {}
            }
        },
        _119 = {
            E = {
                lifeline = {}
            }
        },
        _121 = {
            A = {
                aktivepro_sgms_v = {},
                double_vision_jmesix = {}
            }
        },
        _126 = {
            Asharp = {
                hellion_drake_x_nico_baran_synth_chords = {},
                sushilbawa_vox_sweet_sad_humming_sushilbawa_126 = {}
            },
            Dsharp = {
                shock_atmo = {}
            },
            F = {
                atmospheres_pad = {},
                wind_trap_pad = {}
            }
        },
        _140 = {
            C = {
                drake_x_central_cee_type_loop_by_landsharkszn = {}
            }
        },
        _169 = {
            A = {
                pierre_bourne_type_haven_beats = {}
            },
            Fsharp_m = {
                justron_welcome_to_the_rodelil_skies = {},
                pluto = {}
            }
        },
        _170 = {
            Csharp = {
                street_m_rigotti = {},
                wood_pipe_170 = {}
            }
        },
        _71 = {
            C = {
                dreamscape = {}
            }
        },
        _86 = {
            Fsharp = {
                lofi_rnb_vibe_bpm = {},
                mamagbeats_vinyl_chord_loop_bpm = {},
                mamagbeats_vinyl_chord_loop_bpm_2 = {}
            }
        },
        _87 = {
            F = {
                simple_smooth_rnb_piano_rae_instrumentals = {}
            }
        },
        _92 = {},
        _98 = {
            Dsharp = {
                chords_walk_98 = {}
            },
            F = {
                humming_vocal_sushilbawa_98 = {}
            },
            Fm = {
                silencekills_graphene_synth_fm = {}
            }
        }
    },
    texture = {
        _102 = {
            D = {
                svenley_spacy_delay_ii = {},
                trap_x_pop_inspired_loop = {}
            },
            G = {
                funky_shuffled_bass_guitar_bpm = {}
            }
        },
        _104 = {
            Bm = {
                guitar_in_bm = {}
            },
            G = {
                bouncy_funk_clavi = {},
                distorted_bassline_4 = {}
            }
        },
        _119 = {
            E = {
                drypop_guitar_chords = {},
                synth_119 = {}
            }
        },
        _121 = {
            B = {
                gangsta_bass_shots_pt_1 = {}
            },
            E = {
                hang_poopoopeepee = {},
                happy_guitar_chord_progression = {},
                metamorphosis_guitar_chords = {}
            }
        },
        _126 = {
            F = {
                dj4kat_rain_harp_loop = {},
                electro_edm_catchy_bassline_phrygian_scale = {},
                tropical_rolled_marimba = {}
            }
        },
        _140 = {
            C = {
                bell_trap_beat_bmp_140 = {},
                gltichsaw_c_140 = {},
                unison_bass = {}
            }
        },
        _169 = {
            A = {
                sushilbawa_piano_flavour = {}
            },
            D = {
                dope_808 = {}
            },
            Fsharp_m = {
                flute_march_169 = {}
            }
        },
        _170 = {
            Csharp = {
                chaqui_xcx_no_cap = {},
                dnb_style_bass_1 = {},
                dnb_style_bass_2 = {}
            }
        },
        _71 = {
            Am = {
                easygoing_horns = {}
            },
            G = {
                distorted_electric_guitar_chords = {}
            }
        },
        _86 = {
            B = {
                nostalgic_ambient_vocal_vox_pt2 = {}
            }
        },
        _87 = {
            F = {
                butterflies_kdekappa = {},
                danke_under = {},
                suspicious_japan_flute = {}
            }
        },
        _92 = {
            C = {
                cello_accompaniment = {},
                staccato_trumpet_ensemble_chords = {},
                stevejaz_arpeggios_in_c = {},
                vocoded_vocals = {}
            }
        },
        _98 = {
            Dsharp = {
                sakura = {}
            },
            F = {
                synth_bassline_no1 = {},
                wah_clavi_bassline = {}
            }
        }
    }
}

return {
    tags = tags,
    paths = paths,
    ext = ext,
    applepath = applepath
}
