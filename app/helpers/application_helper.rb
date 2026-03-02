module ApplicationHelper
  include Pagy::Method

  def sidebar_link(label, path, icon: nil)
    active = current_page?(path) || (path != dashboard_path && request.path.start_with?(path))

    content_tag(:li, class: "relative") do
      # Active indicator bar
      indicator = if active
        content_tag(:div, "", class: "absolute left-0 top-1/2 -translate-y-1/2 h-6 w-0.5 rounded-r bg-gradient-to-b from-brand-400 to-accent-400")
      else
        "".html_safe
      end

      css = if active
        "bg-white/10 text-white group flex gap-x-3 rounded-md px-2 py-2 text-sm font-medium"
      else
        "text-gray-400 hover:bg-white/5 hover:text-white group flex gap-x-3 rounded-md px-2 py-2 text-sm font-medium transition-colors"
      end

      indicator + link_to(path, class: css) do
        safe_join([sidebar_icon(icon), label].compact)
      end
    end
  end

  def sidebar_icon(name)
    case name
    when "chart"
      content_tag(:svg, class: "h-5 w-5 shrink-0", fill: "none", viewBox: "0 0 24 24", "stroke-width": "1.5", stroke: "currentColor") do
        tag.path("stroke-linecap": "round", "stroke-linejoin": "round", d: "M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75zM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625zM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V4.125z")
      end
    when "list"
      content_tag(:svg, class: "h-5 w-5 shrink-0", fill: "none", viewBox: "0 0 24 24", "stroke-width": "1.5", stroke: "currentColor") do
        tag.path("stroke-linecap": "round", "stroke-linejoin": "round", d: "M8.25 6.75h12M8.25 12h12m-12 5.25h12M3.75 6.75h.007v.008H3.75V6.75zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zM3.75 12h.007v.008H3.75V12zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0zm-.375 5.25h.007v.008H3.75v-.008zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z")
      end
    when "card"
      content_tag(:svg, class: "h-5 w-5 shrink-0", fill: "none", viewBox: "0 0 24 24", "stroke-width": "1.5", stroke: "currentColor") do
        tag.path("stroke-linecap": "round", "stroke-linejoin": "round", d: "M2.25 8.25h19.5M2.25 9h19.5m-16.5 5.25h6m-6 2.25h3m-3.75 3h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5z")
      end
    end
  end

  def plan_badge(plan)
    colors = { "free" => "bg-gray-100 text-gray-700 ring-1 ring-gray-200", "starter" => "bg-blue-50 text-blue-700 ring-1 ring-blue-200", "pro" => "bg-accent-50 text-accent-700 ring-1 ring-accent-200" }
    content_tag(:span, plan.capitalize, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{colors[plan]}")
  end

  def status_badge(status)
    colors = { "draft" => "bg-gray-50 text-gray-700 ring-1 ring-gray-200", "active" => "bg-green-50 text-green-700 ring-1 ring-green-200", "paused" => "bg-yellow-50 text-yellow-700 ring-1 ring-yellow-200", "launched" => "bg-blue-50 text-blue-700 ring-1 ring-blue-200" }
    content_tag(:span, status.capitalize, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{colors[status]}")
  end
end
