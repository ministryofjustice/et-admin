module Admin
  class UsersImportService
    include ActiveModel::Model
    attr_accessor :tempfile

    def initialize(*)
      super
      self.batch_size = 100
      initialize_role_cache
    end

    def call
      if tempfile.nil?
        errors.add(:tempfile, 'No file given')
        return
      end
      import_csv
    end

    private

    attr_accessor :role_cache, :batch_size

    def initialize_role_cache
      self.role_cache = Hash.new do |hash, key|
        Admin::Role.find_by(name: key).tap do |role|
          hash[key] = role
          raise "Unknown role #{key}" unless role.present?
        end
      end
    end

    def import_csv
      lines = tempfile.readlines("\n").map { |l| l.gsub(/\n\z/, '').gsub(/\r\z/, '') }
      rows = CSV.parse(lines.join("\n"), headers: true)
      dups = duplicate_rows(rows)
      if dups.present?
        errors.add(:tempfile, "The file contains the following duplicates #{dups.join(' - ')}")
        return
      end
      User.transaction do
        begin
          import_in_batches(rows)
        end
      end
    end

    def normalize_row(row)
      {
        username: row['username'],
        name: row['name'],
        email: row['email'],
        password: row['password'],
        password_confirmation: row['password'],
        department: row['department'],
        role_ids: [role_with_name(row['Role'].strip.titleize).id]
      }
    end

    def import_in_batches(rows)
      line_tracker = { number: 1 }
      rows.each_slice(batch_size) do |rows|
        begin
          User.import import_rows(rows, line_tracker), recursive: true
        rescue ActiveRecord::RecordInvalid => ex
          errors.add(:tempfile, "Line #{line_tracker[:number]} - #{ex.message}")
        end
      end
    end

    def import_rows(rows, line_tracker)
      batch = []
      rows.each do |row|
        begin
          line_tracker[:number] += 1
          batch << User.new(normalize_row(row))
        end
      end
      batch
    end

    def duplicate_rows(rows)
      emails = rows.map {|r| r['email']}
      emails.select { |e| emails.count(e) > 1 }
    end

    def role_with_name(name)
      role_cache[name]
    end
  end
end
