class Claim < ApplicationRecord
  self.table_name = :claims
  has_many :claim_claimants
  has_many :claim_respondents
  has_many :claim_representatives
  has_many :claim_uploaded_files
  has_many :secondary_claimants, through: :claim_claimants, class_name: 'Claimant', source: :claimant
  has_many :secondary_respondents, through: :claim_respondents, class_name: 'Respondent', source: :respondent
  has_many :secondary_representatives, through: :claim_representatives, class_name: 'Representative', source: :representative
  has_many :uploaded_files, through: :claim_uploaded_files
  belongs_to :primary_claimant, class_name: 'Claimant'
  belongs_to :primary_respondent, class_name: 'Respondent', optional: true
  belongs_to :primary_repesentative, class_name: 'Representative', optional: true

  def name
    claimant = primary_claimant
    "#{claimant.title} #{claimant.first_name} #{claimant.last_name}"
  end
end
