require 'time'
require 'pathname'

class Zucchini::ReportView
  
  def initialize(features, ci, report_html_path)
    @features    = features
    @device      = features[0].device
    @time        = Time.now.strftime("%T, %e %B %Y")
    @ci          = ci ? 'ci' : ''
    @report_html_path = report_html_path
    
    zucchini_path = File.expand_path(File.dirname(__FILE__))
    assets_path = File.dirname(report_html_path)
    
    unless File.exists?("#{assets_path}/css") then
      `ln -s #{zucchini_path}/css/ #{assets_path}/css`
      `ln -s #{zucchini_path}/js/ #{assets_path}/js`
    end
  end
  
  def get_binding
    binding
  end
    
  def relative_image_path(abs_image_path)
    unless abs_image_path.nil? then
      report_path = Pathname.new(File.expand_path(File.dirname(@report_html_path)))
      rel_image_path = Pathname.new(abs_image_path).relative_path_from(report_path)
    end
  end
end