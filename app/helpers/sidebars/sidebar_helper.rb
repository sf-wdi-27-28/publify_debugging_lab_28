module Sidebars::SidebarHelper
  def sort_archives(sidebar)
    sidebar.archives.sort{|a, b| [a[:year], a[:month]] <=> [b[:year], b[:month]]}.reverse
  end
end
