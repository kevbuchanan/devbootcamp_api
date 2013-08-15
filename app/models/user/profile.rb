class User
  module Profile
    extend ActiveSupport::Concern

    URLS = [:github, :quora, :twitter, :facebook, :linked_in, :blog, :hacker_news]
    PERSONAL = [:about, :hometown, :current_location]
    ATTRIBUTES = URLS + PERSONAL

    included do
      serialize :profile, Hash

      before_validation :normalize_urls

      URLS.each do |url|
        validates_format_of url, :with => URI::regexp, :allow_blank => true, :message => "is an invalid URL"
      end
    end

    # dynamically create getters and setters
    ATTRIBUTES.each do |attr|
      define_method attr do
        profile[attr]
      end

      define_method "#{attr}=" do |arg|
        profile[attr] = arg
      end
    end

    def normalize_urls
      URLS.each do |url|
        begin
          uri = URI.parse self.profile[url]
          self.profile[url] = 'http://' + self.profile[url] if !uri.scheme && self.profile[url].present?
        rescue URI::InvalidURIError
        end
      end
    end
  end
end
