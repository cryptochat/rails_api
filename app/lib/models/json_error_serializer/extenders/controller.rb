module JsonErrorSerializer
  module Extenders
    module Controller

      def serialize_errors(errors, options = {})
        render json: JsonErrorSerializer::Extenders::Serialize.serialize(errors, options), status: :conflict
      end

      def respond_with(err_code, key:nil, message:nil)
        err_name = Rack::Utils::HTTP_STATUS_CODES[err_code].downcase.gsub(' ', '_').to_sym
        render json: JsonErrorSerializer::Extenders::Serialize.error(err_code, key, message), status: err_name
      end

      def valid_json?(json)
        begin
          JSON.parse(json)
          return true
        rescue JSON::ParserError => e
          return false
        end
      end

    end
  end
end
