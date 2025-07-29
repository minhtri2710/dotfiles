return {
  {
    "saghen/blink.cmp",
    dependencies = { "archie-judd/blink-cmp-words" },
    opts = {
      sources = {
        providers = {
          thesaurus = {
            name = "blink-cmp-words",
            module = "blink-cmp-words.thesaurus",
            opts = {
              score_offset = 0,
              pointer_symbols = { "!", "&", "^" },
            },
          },
          dictionary = {
            name = "blink-cmp-words",
            module = "blink-cmp-words.dictionary",
            opts = {
              dictionary_search_threshold = 3,
              score_offset = 0,
              pointer_symbols = { "!", "&", "^" },
            },
          },
        },
        per_filetype = {
          text = { inherit_defaults = true, "dictionary" },
          markdown = { inherit_defaults = true, "thesaurus" },
        },
      },
    },
  },
}
