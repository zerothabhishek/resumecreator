
resumeCreator
-------------

* What is resumeCreator?
It is a web application that helps us write resumes online.


* Where is it hosted?
Right now: http://apps.theabhishek.com


* How is the database organized? How are the models/controllers defined
A user can have many resumes
A resume is thought of containing several parts (education, experience, profiles etc)
So there is a model for user, for the resume, and for each of the parts.
Please look into app/models/user.rb and app/models/resume.rb for association details.

For most of the models, there are corresponding controllers too.
Almost all of the processing takes place within the resume controller.
The <part> controllers are used for some small functionality.
Some common functionality is written in application_controller


* There are just too many files/folders. Where is most of the relevent code?
Yes there are too many stray files, and too much unused code in some files. 
Please look into the following files first, as most of the code is contained in them -
	
	Ruby code:
	app/controllers/resumes_controller.rb
	app/controllers/application_controller.rb
	app/controllers/users_controller.rb
	app/views/resumes/[home/edit/dashboard/options].html.erb
	
	Javascript code:
	public/javascripts/resume_common.js
	public/javascripts/resumes/[options/edit/new].js



* Is most of ruby code in controllers?
As of now, yes. Models contain very little code.
I'm working on the next version where the logic resides in models.


* Where is the documentation? Code comments?
There is no documentation separately. 
There are code comments here and there, but things are pretty disorganized right now.




