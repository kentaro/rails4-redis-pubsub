require 'myapp/job'

class RootController < ApplicationController
  def index; end

  def enqueue
    job_id  = UUID.new.generate
    job = MyApp::Job.new(job_id)
    Rails.queue.push(job)

    render json: { job_id: job_id }
  end
end
