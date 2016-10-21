class AddReportdByReportIssues < ActiveRecord::Migration
  def change
  	add_column :report_issues, :report_by, :string
  end
end
