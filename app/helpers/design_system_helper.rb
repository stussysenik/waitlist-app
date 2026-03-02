module DesignSystemHelper
  def btn_classes(variant: :primary, size: :md)
    base = "inline-flex items-center justify-center font-semibold rounded-lg transition-all duration-200 cursor-pointer"

    sizes = {
      sm: "px-3 py-1.5 text-xs gap-x-1.5",
      md: "px-4 py-2.5 text-sm gap-x-2",
      lg: "px-6 py-3 text-base gap-x-2"
    }

    variants = {
      primary: "bg-gradient-to-r from-brand-500 to-accent-500 text-white shadow-lg shadow-brand-500/25 hover:shadow-brand-500/40 hover:scale-[1.02] active:scale-[0.98]",
      secondary: "bg-white text-gray-700 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50",
      ghost: "text-gray-600 hover:text-gray-900 hover:bg-gray-100",
      danger: "bg-red-50 text-red-700 hover:bg-red-100 ring-1 ring-red-200"
    }

    "#{base} #{sizes[size]} #{variants[variant]}"
  end

  def card_classes(variant: :default)
    base = "rounded-xl bg-white shadow-sm ring-1 ring-gray-900/5"

    variants = {
      default: base,
      interactive: "#{base} hover-lift cursor-pointer",
      gradient_border: "#{base} gradient-border",
      featured: "#{base} ring-2 ring-brand-500/20"
    }

    variants[variant]
  end

  def badge_classes(color: :gray)
    base = "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ring-1 ring-inset"

    colors = {
      gray: "bg-gray-50 text-gray-700 ring-gray-200",
      green: "bg-green-50 text-green-700 ring-green-200",
      yellow: "bg-yellow-50 text-yellow-700 ring-yellow-200",
      blue: "bg-blue-50 text-blue-700 ring-blue-200",
      red: "bg-red-50 text-red-700 ring-red-200",
      brand: "bg-brand-50 text-brand-700 ring-brand-200",
      accent: "bg-accent-50 text-accent-700 ring-accent-200"
    }

    "#{base} #{colors[color]}"
  end
end
