module JsonErrorSerializer
  module Extenders
    module Serialize

      def self.error(err_code, key = nil, message = nil, encryption: true)
        result = {}
        data = {}
        data[:status]  = err_code.to_s

        if key.present? && message.present?
          data[:errors] = {}
          data[:errors][key] = message
        else
          data[:message] = message.nil? ? Rack::Utils::HTTP_STATUS_CODES[err_code] : message
        end

        if encryption
          result[:cipher_message] = Encryption.encrypt(data)
        else
          result = data
        end

        result
      end

      def self.serialize(errors, options = {})
        return if errors.nil?

        result = {}
        json = {}
        json[:errors] = {}

        errors.to_hash(true).each do |key, message|
          json[:errors][key] = message.join('. ') + '.'
        end

        if options.present?
          json[options[:key]] = options[:value]
        end

        result[:cipher_message] = Encryption.encrypt(json)
        result
      end
    end
  end
end
