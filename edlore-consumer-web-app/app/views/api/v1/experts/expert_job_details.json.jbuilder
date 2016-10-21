if !@jobs.blank?

 json.status "success"
 json.job @jobs.each do|expert_job|
  json.(expert_job, :id, :issue_name, :receive_date, :complete_date, :status,:current_status)
 end

elsif @jobs.blank?
 json.status "failure"
 json.message "No Jobs available"
else
 json.status "failure"
 json.message "Something Went Wrong"
end