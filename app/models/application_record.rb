class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :select_all_columns, lambda {
    select(arel_table[Arel.star])
  }

  scope :aq , lambda {|column , operator, *args|
    arel_table[column].public_send(operator , *args)
  }
end
