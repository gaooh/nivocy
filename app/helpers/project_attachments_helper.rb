module ProjectAttachmentsHelper
  
  # byte の値に応じて単位をかえる
  def byte_column(value)
    k = value.to_f / 1024
    if k > 1
      m = k / 1024
      if m > 1
        "#{sprintf("%.1f", m)}M"
      else
        "#{sprintf("%.1f", k)}K"
      end
    else
      "#{value}B"
    end
  end
end
  