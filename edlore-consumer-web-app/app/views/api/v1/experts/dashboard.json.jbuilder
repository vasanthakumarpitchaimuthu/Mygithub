if !@results.blank?

 json.status "success"
 json.news @results.items.each do|item|
   json.title item.title
   des = ActionView::Base.full_sanitizer.sanitize(item.htmlSnippet.html_safe)
   json.description des
   json.image "http://edlore-ind-dev.s3.amazonaws.com/uploads/image/2836_windows-10-aio-100600049-gallery.tablet.jpg?1472129418"
 end

elsif @results.blank?
 json.status "success"
 json.message "No News avilable"
else
 json.status "failure"
 json.message "Something Went wrong"
end