namespace :extract_data do
  desc 'Creates a CSV file with answers from pay, pension and benefits sections of the Employment Details section'
  task employment_details: :environment do
    employment_details = []
    Claim.where(updated_at: 1.year.ago..Time.now).each do |record|
      next if record.employment_details.empty?
      employment_details << record.employment_details.symbolize_keys
                                  .slice(:net_pay,
                                         :net_pay_period_type,
                                         :gross_pay,
                                         :gross_pay_period_type,
                                         :enrolled_in_pension_scheme,
                                         :benefit_details)
    end

    CSV.open('tmp/employment_details.csv', 'wb') do |csv|
      keys = employment_details.first.keys
      csv << keys
      employment_details.each do |hash|
        csv << hash.values
      end
    end
  end

  desc 'Prints the percentage of employment_details completed from all claims complete'
  task employment_details_completion_rate: :environment do
    include ActiveSupport::NumberHelper
    number_completed = Claim.where(updated_at: 1.year.ago..Time.now)
                            .where.not(employment_details: {}).count.to_f
    total_completed = Claim.where(updated_at: 1.year.ago..Time.now).count.to_f

    puts number_to_percentage(number_completed / total_completed, precision: 2)
  end

end
