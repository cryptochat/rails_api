module JsonErrorSerializer
  module Extenders
    module Serialize

      def self.error(err_code, key = nil, message = nil)
        data = {}
        data[:status]  = err_code.to_s

        if key.present? && message.present?
          data[:errors] = {}
          data[:errors][key] = message
        else
          data[:message] = message.nil? ? Rack::Utils::HTTP_STATUS_CODES[err_code] : message
        end

        data
      end

      def self.serialize(errors, options = {})
        return if errors.nil?

        json = {}
        json[:errors] = {}

        errors.to_hash(true).each do |key, message|
          json[:errors][key] = message.join('. ') + '.'
        end

        if options.present?
          json[options[:key]] = options[:value]
        end

        json
      end

    end
  end
end
