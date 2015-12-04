module ApplicationHelper

  def render_breadcrumb(node)
    if node.kind_of?(Node)
      key_string = node.key || ""
    else
      key_string = node || ""
    end

    links = []
    parts = key_string.split("/")
    parts.each_with_index do |part, i|
      next if part == ""
      if i == parts.length - 1
        links << part
      else
        key = key_string.split(part).first + "/#{part}"
        links << link_to(part, key_path(key))
      end
    end
    ("/ " + links.join(" / ")).html_safe
  end

  def relative_key(base, node)
    node.key.sub(/^#{base.key}\/?/, "")
  end

end
