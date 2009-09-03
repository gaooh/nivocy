# Methods added to this helper will be available to all templates in the application.
require "text/hatena"

module ApplicationHelper
  
  # パン屑
  def breadcrumb
    
    breadcrumb_array = Array.new
    breadcrumb_array << @content_for_breadcrumb_controller
    breadcrumb_array << @content_for_breadcrumb_action
    breadcrumb_array << @content_for_breadcrumb_id
    
    unless breadcrumb_array[0].nil?
      breadcrumb = ''
      breadcrumb << link_to("HOME", :controller => :home) if @controller.controller_name != "home"
    
      breadcrumb_array.each do | part | 
        unless part.nil?
          breadcrumb << ' > '
          breadcrumb << part
        end
      end
    end
    
    breadcrumb
  end
  
  # icon image 用
  def icon_image_tag(source)
    source = "icons/" + source + ".gif" 
    image_tag(source, :size =>'16x16', :class=>'icon', :alt=>'icon')
  end
  
  # button image submit 用
  def button_image_submit_tag(source)
    source = "buttons/" + source + ".gif" 
    image_submit_tag(source, :alt=>'button', :class=>"submit_button")
  end
  
  # ajax を用いた form の　button image submit 
  def button_image_remote_submit_tag(source)
    source = "/images/buttons/" + source + ".gif"
    #submit_to_remote("submit", "submit", { :type => 'image', :src => source, :alt=>'button', :class=>"submit_button" })
    options = Hash.new
    options[:with] ||= 'Form.serialize(this.form)'

            options[:html] ||= {}
            options[:html][:type] = 'image'
            options[:html][:src] = source
            options[:html][:class] = "submit_button"
            options[:html][:onclick] = "#{remote_function(options)}; return false;"
            options[:html][:name] = "submit"
            options[:html][:value] = "submit"
            options[:url] ||= {}
            options[:url][:action] = "ajax_create"
            tag("input", options[:html], false)
            
  end
    	
  # user image 用
  # image_tag を使うと　.png が自動的に補完されるのでつかわない
  def user_image(user)
    "<img src=\"https://intra.office.drecom.jp/#{user.office_id}/file/profile\" width=\"50px\" >"
  end
  
  # icon + text のリンクを作る
  def link_to_icon_text(icon, text, options = {}, html_options = nil, *parameters_for_method_reference)
    name = ""
    name << icon_image_tag(icon)
    name << text
    link_to(name, options, html_options, parameters_for_method_reference)
  end
  
  # icon + text のjavascriptリンクを作る
  def link_to_function_icon_text(icon, text, function, html_options = {})
    name = ""
    name << icon_image_tag(icon)
    name << text
    link_to_function(name, function, html_options)
  end
  
  # サインイン済みか
  def signin?
    session[:user].nil? ? false : true
  end
  
  # ログイン済みのユーザ名
  def user_name
    session[:user].nil? ? "" : User.find_by_id(session[:user]).name
  end
  
  # ログイン済みのユーザID
  def user_id
    session[:user]
  end
  
  # ログイン済みのユーザemail
  def user_email
    session[:user].nil? ? "" : User.find_by_id(session[:user]).email
  end
  
  def select_hour_minute(datetime, options = {})
    hour_minute_options = []
    
    0.upto(23) do |hour|
      minute_step = options[:minute_step].nil? ? 30 : options[:minute_step]
      0.step(59, minute_step) do |minute|
        if datetime.hour == hour && datetime.min == minute
          hour_minute_options << %(<option value="#{leading_zero_on_single_digits(hour)}:#{leading_zero_on_single_digits(minute)}" selected>
                                  #{leading_zero_on_single_digits(hour)}:#{leading_zero_on_single_digits(minute)}</option>)
        else
          hour_minute_options << %(<option value="#{leading_zero_on_single_digits(hour)}:#{leading_zero_on_single_digits(minute)}">
                                  #{leading_zero_on_single_digits(hour)}:#{leading_zero_on_single_digits(minute)}</option>)
        end
      end
    end
    
    select_html(options[:field_name] || 'hour_minute', hour_minute_options, options)
  end
  
  # paginate number 
  # ex) prev 1 2 3 next
  def paginate_number(number, current, param = nil)
    return if number.to_i == 1 # 1ページしかない場合は表示しない
    result = ""
    1.upto(number.to_i) { |i|
      if i == current
        result.concat(i.to_s)
      else
        if param.nil?
          result.concat(link_to i, :page => i)
        else
          result.concat(link_to i, :page => i, :search => param)
        end
      end
      result.concat("&nbsp;")
    }
    result
  end
  
  # 表示中ページのアイテム番号のはじめをかえす
  def paginate_first_number(pages)
    return (pages.current.number-1) * pages.items_per_page + 1
  end
  
  # 表示中ページのアイテム番号の最後をかえす
  def paginate_last_number(pages)
    last = pages.current.number * pages.items_per_page
    return last > pages.item_count ? pages.item_count : last
  end
  
  # 利用するカレンダーのスタイルはコンテナ用か
  def container_calendar?
    if !@container_calendar.nil? && @container_calendar
      return true
    end
    return false 
  end
  
  #　はてな記法のHTMLへ変換
  def to_hatena(text)
    parser = Text::Hatena.new
    text.gsub!(/<br>/,"\n\r");
    parser.parse(text)
    parser.html
  end
  
  # 携帯のアクセスキー対応
  def link_to_mobile(key, name, options={}, html_options=nil, *parameters_for_method_reference)
    html_options = {:accesskey=>key}
    case key # 最適化する方法あるはず
    when 1
      emoji = "&#xE6E2;"
    when 2
      emoji = "&#xE6E3;"
    when 3
      emoji = "&#xE6E4;"
    when 4
      emoji = "&#xE6E5;"
    when 5
      emoji = "&#xE6E6;"
    when 6
      emoji = "&#xE6E7;"
    when 7
      emoji = "&#xE6E8;"
    when 8
      emoji = "&#xE6E9;"
    when 9
      emoji = "&#xE6EA;"
    when 0
      emoji = "&#xE6EB;"
    else
      emoji = ""
    end
    link_to("#{emoji}#{name}", options, html_options, *parameters_for_method_reference)
  end
  
  # 日付用のフォーマットに変換
  def format_day(value)
    return if value.nil?
    value.strftime("%Y/%m/%d")
  end
  
  # 標準のin_place_editorにonComplete追加
  def in_place_editor(field_id, options = {})
    function =  "new Ajax.InPlaceEditor("
    function << "'#{field_id}', "
    function << "'#{url_for(options[:url])}'"

    js_options = {}
    
    js_options['cancelText'] = %('#{options[:cancel_text]}') if options[:cancel_text]
    js_options['okText'] = %('#{options[:save_text]}') if options[:save_text]
    js_options['loadingText'] = %('#{options[:loading_text]}') if options[:loading_text]
    js_options['savingText'] = %('#{options[:saving_text]}') if options[:saving_text]
    js_options['rows'] = options[:rows] if options[:rows]
    js_options['cols'] = options[:cols] if options[:cols]
    js_options['size'] = options[:size] if options[:size]
    js_options['externalControl'] = "'#{options[:external_control]}'" if options[:external_control]
    js_options['loadTextURL'] = "'#{url_for(options[:load_text_url])}'" if options[:load_text_url]        
    js_options['ajaxOptions'] = options[:options] if options[:options]
    js_options['evalScripts'] = options[:script] if options[:script]
    js_options['callback']   = "function(form) { return #{options[:with]} }" if options[:with]
    js_options['clickToEditText'] = %('#{options[:click_to_edit_text]}') if options[:click_to_edit_text]
    
    js_options['onComplete'] = "function() { #{options[:on_complete]} }" if options[:on_complete]
    #js_options['onComplete'] = options[:on_complete] if options[:on_complete]
    
    function << (', ' + options_for_javascript(js_options)) unless js_options.empty?
    function << ')'

    javascript_tag(function)
  end
end
