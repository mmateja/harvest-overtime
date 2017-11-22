# frozen_string_literal: true

class BusinessDaysComputer
  def business_days(start_date, end_date)
    (start_date..end_date).reject(&:saturday?).reject(&:sunday?)
  end
end
