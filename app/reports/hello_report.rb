		# in app/reports/hello_report.rb:
		class HelloReport < Prawn::Document
			def to_pdf
      			text "Hello world"
      			render
    		end
  		end