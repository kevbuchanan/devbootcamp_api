require 'csv'

class User
  class Import
    attr_accessor :cohort_id, :rows

    EMAIL_HEADER = "Email Address"
    NAME_HEADER  = "Name"

    def initialize(cohort_id, file)
      self.cohort_id = cohort_id
      self.rows = CSV.parse(file.read)
    end

    def process!
      results = { :new => 0, :updated => 0 }

      # this operation could be slow, keep it out of the transaction.
      attributes = extract_users_attributes

      # updates all or none.
      User.transaction do
        attributes.each do |email, attributes|
          u = User.find_or_create_by_email(email)

          u.cohort_id = self.cohort_id
          u.roles = ["student"]
          u.generate_password!

          if u.new_record?
            results[:new] += 1
          else
            results[:updated] += 1
          end

          u.update_attributes!(attributes)
        end
      end

      results
    end

    private

    # Makes assumptions about CSV header format.
    # Returns a hash in the form:
    #   { email_address => user_attributes }
    def extract_users_attributes
      users_attributes = {}

      headers = rows.shift
      email_index = headers.index(EMAIL_HEADER)
      name_index = headers.index(NAME_HEADER)

      rows.each do |row|
        email = row[email_index]
        name = row[name_index]

        users_attributes[email] = { :name => name }
      end
      users_attributes
    end
  end
end
