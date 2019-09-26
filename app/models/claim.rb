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

  has_many :exports, as: :resource

  scope :not_exported, -> { joins("LEFT JOIN \"exports\" ON \"exports\".\"resource_id\" = \"claims\".\"id\" AND \"exports\".\"resource_type\" = 'Claim'").where(exports: {id: nil}) }
  scope :not_exported_to_ccd, -> { joins("LEFT OUTER JOIN \"exports\" ON \"exports\".\"resource_id\" = \"claims\".\"id\" AND \"exports\".\"resource_type\" = 'Claim' LEFT OUTER JOIN \"external_systems\" ON \"exports\".\"external_system_id\" = \"external_systems\".\"id\" AND \"external_systems\".\"reference\" ~ 'ccd'").where(external_systems: {id: nil}) }

  def name
    claimant = primary_claimant
    "#{claimant.title} #{claimant.first_name} #{claimant.last_name}"
  end

  def as_json(options = {})
    super(options.merge include: :uploaded_files)
  end
end
