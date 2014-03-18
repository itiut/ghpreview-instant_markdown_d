require 'ghpreview/wrapper'

GHPreview::Wrapper.class_eval do
  remove_const :STYLED_TEMPLATE_FILEPATH
  const_set :STYLED_TEMPLATE_FILEPATH, "/tmp/ghpreview-instant_makrdown_d-template.erb"

  remove_const :RAW_TEMPLATE_FILEPATH
  const_set :RAW_TEMPLATE_FILEPATH, "#{File.dirname(__FILE__)}/template.erb"
end
