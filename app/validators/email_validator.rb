class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ Regex.email
      record.errors[attribute] << (options[:message] || 'is not an email')
    end
  end
end
