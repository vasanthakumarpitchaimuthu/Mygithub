if @expert_tags.present?
  json.status "1"
  json.expert_tags @expert_tags do |tag|
    json.(tag, :id, :tag_name)
  end
else
  json.status "0"
  json.message "No Tags found"
end
