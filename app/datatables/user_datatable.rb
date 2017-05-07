class UserDatatable < AjaxDatatablesRails::Base
  include AjaxDatatablesRails::Extensions::Kaminari

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(User.id User.email User.username User.first_name User.last_name)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(User.id User.email User.username User.first_name User.last_name)
  end

  private

  def data
    records.map do |record|
      [
        record.id,
        record.email,
        record.username,
        record.first_name,
        record.last_name,
        record.status,
        record.edit_link
      ]
    end
  end

  def get_raw_records
    User.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
