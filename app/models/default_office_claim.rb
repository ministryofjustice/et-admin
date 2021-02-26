class DefaultOfficeClaim < Claim
  self.inheritance_column = :none
  default_scope -> { joins(:office).where(office: { is_default: true }) }
end
