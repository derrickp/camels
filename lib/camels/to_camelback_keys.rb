require 'camels/camelize'

module Camels
  class ToCamelbackKeys
    include Camels::Camelize

    def call(value:, acronyms: {})
      case value
      when Array
        value.map { |v| call(value: v, acronyms: acronyms) }
      when Hash
        Hash[value.map { |k, v| [camelize_key(k, acronyms, false), call(value: v, acronyms: acronyms)] }]
      else
        value
      end
    end
  end
end
