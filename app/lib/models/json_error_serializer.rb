module JsonErrorSerializer
  require 'models/json_error_serializer/extenders/serialize'
end

require 'models/json_error_serializer/extenders/controller'
ActiveSupport.on_load(:action_controller) do
  include JsonErrorSerializer::Extenders::Controller
end
