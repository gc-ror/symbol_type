require 'active_model'

module SymbolType
  #
  # ターゲット型: 設問やオプションがどちら向きか？(自己/他者/両方)を設定する
  #
  class SymbolValue < ActiveModel::Type::Value
    #
    # 値
    #
    class Value
      #
      # @return SymbolValue
      #
      attr_reader :type

      #
      # @return [Integer]
      #
      attr_reader :value

      #
      # @param [SymbolValue] type
      # @param [Integer] value
      #
      def initialize(type, value)
        raise ArgumentError, value.inspect unless type.integer_to_symbol.key? value

        @type = type
        @value = value
      end

      def ==(other)
        case other
        when Integer
          value == other
        when String
          value == type.string_to_integer[other]
        when Symbol
          value == type.symbol_to_integer[other]
        when Value
          value == value.to_i
        else
          false
        end
      end

      def in(*values)
        values.any? { |value| self == value }
      end

      #
      # @return [Integer]
      #
      def to_i
        value
      end

      def to_s
        type.integer_to_string[value]
      end

      def to_sym
        type.integer_to_symbol[value]
      end

      def inspect
        to_s
      end
    end

    attr_reader :name, :symbol_to_integer, :full_mapping

    #
    # @param [Symbol] name 系列名
    # @param [Hash] mapping シンボルからIDへのマッピング
    #
    def initialize(name, **mapping)
      @name = name
      @symbol_to_integer = mapping.freeze
    end

    def integer_to_symbol
      @integer_to_symbol ||= symbol_to_integer.to_a.map(&:reverse).to_h.freeze
    end

    def integer_to_string
      (@integer_to_string ||= {})[I18n.locale] ||= integer_to_symbol.map do |integer, symbol|
        [integer, I18n.t("symbol_values.#{name}.#{symbol}")]
      end.to_h.freeze
    end

    def string_to_integer
      (@string_to_integer ||= {})[I18n.locale] ||= integer_to_symbol.map do |integer, symbol|
        [symbol.to_s, integer]
      end.to_h.merge(integer_to_string.map(&:reverse).to_h).freeze
    end

    def any_to_integer
      (@any_to_integer ||= {})[I18n.locale] ||=
        symbol_to_integer.values.map { |i| [i, i] }.to_h.merge(symbol_to_integer).merge(string_to_integer).freeze
    end

    def type
      :symbol_value
    end

    def changed_in_place?(raw_old_value, new_value)
      raw_old_value != cast_value(new_value)&.to_i
    end

    def serialize(value)
      value.is_a?(Value) ? value.to_i : any_to_integer[value]
    end

    private

    def cast_value(value)
      if value.is_a? Value
        value
      else
        integer = any_to_integer[value]
        integer.present? ? Value.new(self, integer) : nil
      end
    end
  end
end
