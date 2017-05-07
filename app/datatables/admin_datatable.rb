class AdminDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= %w(Admin.id Admin.email Admin.current_sign_in_ip Admin.created_at Admin.updated_at)
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= %w(Admin.id Admin.email Admin.current_sign_in_ip Admin.created_at Admin.updated_at)
  end

  private

  def data
    records.map do |record|
      [
        record.id,
        record.email,
        record.current_sign_in_ip.to_s,
        record.created_at,
        record.updated_at,
        record.edit_link
      ]
    end
  end

  def get_raw_records
    Admin.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
