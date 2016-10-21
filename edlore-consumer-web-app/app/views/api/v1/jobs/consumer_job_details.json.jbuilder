if !@jobs.blank?

 json.status "success"
 json.job @jobs.each do|consumer_job|
  json.(consumer_job, :id, :issue_name, :receive_date,  :complete_date, :status)
 end

elsif @jobs.blank?
 json.status "failure"
 json.message "No Jobs avilable"
else
 json.status "failure"
 json.message "Something Went wrong"
end