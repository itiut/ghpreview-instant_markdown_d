require 'ghpreview/wrapper'

GHPreview::Wrapper.class_eval do
  remove_const :RAW_TEMPLATE_FILEPATH
  const_set :RAW_TEMPLATE_FILEPATH, "#{File.dirname(__FILE__)}/template.erb"
end
