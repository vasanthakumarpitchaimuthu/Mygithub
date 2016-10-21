class CreateReportIssues < ActiveRecord::Migration
  def change
    create_table :report_issues do |t|
      t.string :description
      t.integer :job_id

      t.timestamps
    end
  end
end
