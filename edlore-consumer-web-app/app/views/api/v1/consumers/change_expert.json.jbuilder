if !@all_experts.blank?

 json.status "success"
 json.experts @all_experts.each do|exp|
  json.(exp, :expert_id, :expert_name, :rating, :total_ratings,
        :job_completed, :distance, :minutes, :cat_id, :sub_cat, :job_id, :address)
 end

elsif @all_experts.blank?
 json.status "failure"
 json.message "No experts avilable"
else
 json.status "failure"
 json.message "Something Went wrong"
end


