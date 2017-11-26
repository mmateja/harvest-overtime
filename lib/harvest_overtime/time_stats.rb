# frozen_string_literal: true

TimeStats = Struct.new(:business_hours, :billed_hours) do
  def overtime
    billed_hours - business_hours
  end
end
