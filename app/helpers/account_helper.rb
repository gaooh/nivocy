module AccountHelper
  
  # 部署一覧tree表示
  def division_trees(user, divisions)
    
    if divisions.size > 0
        tree_id = "tree_#{divisions.first.parent_id}"
        style_tree = tree_id == 'tree_' ? 'display:show' : 'display:none'
        html = "<ul id='#{tree_id}' style='#{style_tree}'>\n<li></li>\n"
        divisions.each do |division|
          html << "<li id='item_#{division.id}'>"
          if division.children.size > 0
            style_show = 'display:none'
          else
            style_hide = 'display:none'
          end
          html << link_to_function(icon_image_tag('bullet_toggle_plus'), 
                    "Element.toggle('tree_#{division.id}');
                     Element.toggle('show_#{division.id}');
                     Element.toggle('hide_#{division.id}')", 
                    :class=>"toggle_hide", :id=>"hide_#{division.id}", :style=>style_hide)
          html << "#{h(division.name)}\n"
          
          if user.nil?
            html << "<input type=\"checkbox\" name=\"divisions[]\" value=\"#{division.id}\"/>"
          else
            checked_flag = false
            user.divisions.each { |u_division| checked_flag = true if u_division.id == division.id }
            if checked_flag
              html << "<input type=\"checkbox\" name=\"divisions[]\" value=\"#{division.id}\"/ checked=\"checked\">"
            else
              html << "<input type=\"checkbox\" name=\"divisions[]\" value=\"#{division.id}\"/>"
            end
          end
          
          if division.children.size > 0
            html << division_trees(user, division.children)
          else
            html << "<ul id='tree_#{division.id}'>\n<li></li>\n</ul>\n"
          end
          html << "</li>\n"
        end
      html << "</ul>\n"
    end
    
  end
    
end
