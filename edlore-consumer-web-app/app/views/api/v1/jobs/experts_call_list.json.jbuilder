if !@experts.blank?

 json.status "success"
 json.experts @all_experts.each do|exp|
   json.(exp,:id, :expert_id, :first_name, :avg_rating, :expert_user_id, :expert_device_token, :distance)
 end
elsif @experts.blank?
 json.status "failure"
 json.message "No experts avilable"
else
 json.status "failure"
 json.message "Something Went wrong"
end
