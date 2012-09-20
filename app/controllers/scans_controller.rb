class ScansController < ApplicationController
	def last30Scans
		@scans = Scan.find(:all, :order => "updated_at desc", :limit => 30)
		@scans.each do |scan|
			scan["latitude"] = scan.tag.latitude
			scan["longitude"] = scan.tag.longitude
		end
		respond_to do |format|
			format.json {render json: @scans}
		end


	end

end
