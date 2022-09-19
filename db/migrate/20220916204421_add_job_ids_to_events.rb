class AddJobIdsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :early_job_id, :string
    add_column :events, :prelims_job_id, :string
    add_column :events, :main_job_id, :string
  end
end
