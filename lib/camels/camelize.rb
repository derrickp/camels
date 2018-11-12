module Camels
  module Camelize
    def camelize_key(key, acronyms, first_upper = true)
      if key.is_a? Symbol
        camelize(key.to_s, acronyms, first_upper).to_sym
      elsif key.is_a? String
        camelize(key, acronyms, first_upper)
      else
        key # We can't camelize anything except strings and symbols
      end
    end

    def camelize(snake_word, acronyms, first_upper = true)
      if first_upper
        capitalize_first(snake_word, acronyms)
      else
        parts = snake_word.split('_', 2)
        parts[0] << camelize(parts[1], acronyms) if parts.size > 1
        parts[0] || ''
      end
    end

    def capitalize_first(snake_word, acronyms)
      first_update = snake_word.to_s.gsub(/(?:^|_)([^_\s]+)/) do
        acronyms[Regexp.last_match(1)] || Regexp.last_match(1).capitalize
      end

      first_update.gsub(%r{/([^/]*)}) do
        '::' + (acronyms[Regexp.last_match(1)] || Regexp.last_match(1).capitalize)
      end
    end
  end
end
