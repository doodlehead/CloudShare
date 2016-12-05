class Asset < ApplicationRecord
  attr_accessor :user_id, :uploaded_file
  #belongs_to :user
  
  has_attached_file :uploaded_file
  
  validates_attachment_size :uploaded_file, :less_than => 100.megabytes
  validates_attachment_presence :uploaded_file 
  
  #Starting with paperclip 4.0, file type and content type must be validated,
  #or explicitly stated that they do not have to be.
  
  do_not_validate_attachment_file_type :uploaded_file
end
