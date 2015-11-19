module ApplicationHelper

  def render_breadcrumb(node)
    links = []
    parts = node.key.split("/")
    node.key.split("/").each_with_index do |part, i|
      next if part == ""
      if i == parts.length - 1
        links << part
      else
        key = node.key.split(part).first + "/#{part}"
        links << link_to(part, key_path(key))
      end
    end
    ("/ " + links.join(" / ")).html_safe
  end

  def relative_key(base, node)
    node.key.sub(/^#{base.key}\/?/, "")
  end

end
