module ApplicationHelper
 #get category list
 def category_list
  @categories = Category.all
  (@categories.map{ |f| [f.category_name,f.id] })
 end
 #get sub category list
 def sub_cat_list
  @sub_categories = SubCategory.all
  (@sub_categories.map{ |f| [f.sub_cat_name,f.id] })
 end
end
