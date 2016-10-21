if !@reviews.blank?

 json.status "success"
 json.review @review_list.each do|rev|
  json.(rev, :consumer_id, :consumer_name, :exp_id, :exp_name, :job_id,:issue_name, :rating, :feedback, :status, :comp_date)
 end

elsif @reviews.blank?
 json.status "failure"
 json.message "No reviews avilable"
else
 json.status "failure"
 json.message "Something Went wrong"
end