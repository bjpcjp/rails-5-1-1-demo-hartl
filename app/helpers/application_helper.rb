module ApplicationHelper

	# listing 4.2

	def full_app_title(page_title='')
		base_title = "Demo"
		if page_title.empty?
			base_title
		else
			base_title + " | " + page_title
		end
	end

end
