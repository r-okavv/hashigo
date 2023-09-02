class RestaurantDecorator < ApplicationDecorator
  delegate_all

  def price_level_str
    case object.price_level
    when 0
      "無料"
    when 1
      "安価"
    when 2
      "お手頃"
    when 3
      "高級"
    when 4
      "とても高級"
    else
      "不明"
    end
  end
end
