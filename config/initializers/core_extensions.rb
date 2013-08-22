class ActiveRecord::Base
  def self.page(options = {})
    if options[:per_page]
      limit = options[:per_page].to_i
    else
      return self.all
    end
    if options[:page]
      offset = (options[:page].to_i - 1) * limit
    else
      offset = 0
    end
    self.offset(offset).limit(limit)
  end
end
