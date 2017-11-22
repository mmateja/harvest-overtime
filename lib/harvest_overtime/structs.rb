Month = Struct.new(:year, :month) do
  def self.from_date(date)
    new(date.year, date.month)
  end

  def to_s
    "#{year}-#{month.to_s.rjust(2, '0')}"
  end
end

MonthStats = Struct.new(:month, :business_hours, :billed_hours) do
  def overtime
    billed_hours - business_hours
  end
end

TimeEntry = Struct.new(:date, :hours) do
  def month
    Month.new(date.year, date.month)
  end
end
