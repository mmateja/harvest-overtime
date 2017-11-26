# frozen_string_literal: true

Month = Struct.new(:year, :month) do
  def self.from_date(date)
    new(date.year, date.month)
  end

  def to_s
    "#{year}-#{month.to_s.rjust(2, '0')}"
  end
end
