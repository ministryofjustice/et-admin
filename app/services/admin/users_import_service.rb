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
        ::Role.find_by(name: key).tap do |role|
          hash[key] = role
          raise "Unknown role #{key}" unless role.present?
        end
      end
    end

    def import_csv
      lines = tempfile.readlines("\n").map { |l| l.gsub(/\n\z/, '').gsub(/\r\z/, '') }
      rows = CSV.parse(lines.join("\n"), headers: true)
      dups = duplicate_emails(rows)
      if dups.present?
        errors.add(:tempfile, "The file contains the following duplicate emails #{dups.join(' - ')}")
      end
      dups = duplicate_usernames(rows)
      if dups.present?
        errors.add(:tempfile, "The file contains the following duplicate usernames #{dups.join(' - ')}")
      end
      return if errors.present?
      User.transaction do
        begin
          import_in_groups(rows)
        end
      end
    end

    def normalize_row(row)
      {
        username: row['username'],
        name: row['name'],
        email: row['email'].downcase,
        password: row['password'],
        password_confirmation: row['password'],
        department: row['department']
      }
    end

    def import_in_groups(outer_rows)
      grouped = outer_rows.group_by {|row| [row['password'], row['Role'].strip.titleize]}
      grouped.each_pair do |(_password, role_name), rows|
        import_grouped_rows(role_name, rows)
      end
    end

    def import_grouped_rows(role_name, rows)
      return if rows.length == 0
      role = Role.find_by(name: role_name)
      default_attributes = { }
      new_user = User.create!(normalize_row(rows.first).merge(default_attributes).merge(role_ids: [role.id]))
      default_attributes.merge!(new_user.attributes.as_json.symbolize_keys.slice(:encrypted_password, :permission_names, :is_admin))

      batch = rows[1..-1].map do |row|
        normalize_row(row).except(:password, :password_confirmation).merge(default_attributes)
      end
      ids = User.import(batch, recursive: true, validate: false).ids
      UserRole.import ids.map {|id| {user_id: id, role_id: role.id}}
    end

    def duplicate_emails(rows)
      emails = rows.map {|r| r['email'].downcase}
      emails.select { |e| emails.count(e) > 1 }
    end

    def duplicate_usernames(rows)
      usernames = rows.map {|r| r['username']}
      usernames.select { |e| usernames.count(e) > 1 }
    end
  end
end
