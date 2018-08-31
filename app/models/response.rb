# frozen_string_literal: true
class Response < ApplicationRecord
  self.table_name = :responses

  belongs_to :respondent
  belongs_to :representative
  has_many :response_uploaded_files, dependent: :destroy
  has_many :uploaded_files, through: :response_uploaded_files

end
