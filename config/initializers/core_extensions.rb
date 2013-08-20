class ActiveRecord::Base
  def self.page(options)
    limit = options[:per_page] || 20
    if options[:page]
      offset = (options[:page] - 1) * per_page
    else
      offset = 0
    end
    self.offset(offset).limit(limit)
  end
end
