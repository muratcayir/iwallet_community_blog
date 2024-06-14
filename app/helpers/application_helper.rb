module ApplicationHelper
  def active_class(link_path)
    current_page?(link_path) ? 'bg-gray-800' : 'bg-gray-500'
  end
end
