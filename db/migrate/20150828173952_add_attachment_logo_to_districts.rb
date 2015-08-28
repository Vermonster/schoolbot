class AddAttachmentLogoToDistricts < ActiveRecord::Migration
  DUMMY_LOGO = File.open(
    Rails.root.join('spec', 'support', 'files', 'dummy512.svg')
  )

  def change
    add_attachment :districts, :logo

    reversible do |dir|
      dir.up do
        District.find_each do |district|
          district.update!(logo: DUMMY_LOGO)
        end
      end
    end

    change_column_null :districts, :logo_file_name, false
    change_column_null :districts, :logo_file_size, false
    change_column_null :districts, :logo_content_type, false
    change_column_null :districts, :logo_updated_at, false
  end
end
