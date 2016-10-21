if !@manuals.blank?

 json.status "success"
 json.manuals @consumer_manuals.each do|manu|
  json.(manu, :id, :manual_name, :manual_url, :create_date)
 end

elsif @manuals.blank?
 json.status "success"
 json.message "No manuals avilable"
else
 json.status "failure"
 json.message "Something Went wrong"
end


