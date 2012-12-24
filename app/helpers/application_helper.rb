module ApplicationHelper
  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end
  
  def l(code, category)
    @lookup = Lookup.where(" code = ? and category = ? ", code.to_s, category).first
    @lookup.nil? ? code : @lookup.description
  end
  
  def settings(key)
    @switch = Switch.where(" key = ? ", key).first
    @switch.nil? ? nil : @switch.value
  end
  
end
