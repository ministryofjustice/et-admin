require "uk_postcode"
class PostcodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    ukpc = UKPostcode.parse(value)
    unless ukpc.full_valid?
      record.errors[attribute] << 'Not a valid UK postcode'
    end
  end
end