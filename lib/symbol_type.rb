# frozen_string_literal: true

require 'symbol_type/symbol_value'

#
# SymbolType
#
# ActiveModel の型として定義する。
#
#
module SymbolType
  def register
    ActiveModel::Type.register(:target, SymbolValue)
    ActiveRecord::Type.register(:target, SymbolValue)
  end
end
