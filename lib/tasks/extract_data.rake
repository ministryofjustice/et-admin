namespace :extract_data do
  desc 'Creates a CSV file with answers from sections 5, 6 and 9 of the paper form'
  task :policy_csv, [:year, :month_as_int] => [:environment] do |task, args|
    first_of_month = Date.new(args[:year].to_i, args[:month_as_int].to_i)
    last_of_month = Date.new(args[:year].to_i, args[:month_as_int].to_i, -1)
    policy_data = []
    Claim.where(updated_at: first_of_month..last_of_month).each do |record|
      next if record.employment_details.empty?
      record_hash = record.employment_details.symbolize_keys
                          .slice(:net_pay,
                                 :net_pay_period_type,
                                 :gross_pay,
                                 :gross_pay_period_type,
                                 :enrolled_in_pension_scheme,
                                 :benefit_details,
                                 :start_date,
                                 :end_date,
                                 :notice_period_end_date,
                                 :job_title)
      record_hash[:desired_outcomes] = record.desired_outcomes
      record_hash[:other_outcome] = record.other_outcome
      policy_data << record_hash
    end

    CSV.open('tmp/policy_data.csv', 'wb') do |csv|
      keys = policy_data.first.keys
      csv << keys
      policy_data.each do |hash|
        csv << hash.values
      end
    end
  end

  desc 'Prints the percentage of employment_details completed from all claims complete since 8th October 2018'
  task employment_details_completion_rate: :environment do
    include ActiveSupport::NumberHelper
    number_completed = Claim
                       .where(updated_at: Date.parse('2018-10-08')..Time.now)
                       .where.not(employment_details: {}).count.to_f
    total_completed = Claim
                      .where(updated_at: Date.parse('2018-10-08')..Time.now)
                      .count.to_f

    puts number_to_percentage((number_completed / total_completed) * 100,
                              precision: 2)
  end
end
