class UsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "must begin with an uppercase or lowercase letter") unless
      value.first =~ /\A[a-zA-Z]\z/

    record.errors[attribute] << (options[:message] || "must consist of alphanumeric characters only") unless
      value =~ /\A[a-zA-Z]\w{3,29}\z/
  end
end
