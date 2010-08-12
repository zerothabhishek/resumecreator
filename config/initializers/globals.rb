
PART_TITLES_ALL = ["contact", "profile", "skills", "education", "experiences", "hobbies", "achievements"]


# contact
CONTACT_SUBPART = 	{	:title => "", 
						:meta_desc => "", 
						:keyvaluepairs => {	"0" => { :key => "address", 	:value => "" },
											"1" => { :key => "phone_nos",	:value => "" },
											"2" => { :key => "emails",		:value => "" }	}	}
CONTACT = 			{	:title => "contact", 
						:meta_desc => "stores contact data",
						:subparts => { "0" => CONTACT_SUBPART }	}

# profile				
PROFILE_SUBPART = 	{	:title => "", 
						:meta_desc => "", 
						:keyvaluepairs => {	"0" => { :key => "", 	:value => "" }	}	}	
PROFILE = 			{	:title => "profile", 
						:meta_desc => "stores profile data - key value pairs have no key - only data this part holds is the title and the value",
						:subparts => { "0" => PROFILE_SUBPART } }



# skills
SKILLS_SUBPART = 	{	:title => "", 
						:meta_desc => "", 
						:keyvaluepairs => { "0" => { :key => "skill name", 		:value => "" },
											"1" => { :key => "expertise level",	:value => "" },
											"2" => { :key => "remarks",			:value => "" }	}	}
SKILLS = 			{	:title => "skills", 
						:meta_desc => "stores skill data",
						:subparts => { "0" => SKILLS_SUBPART } } 			

# education	
EDUCATION_SUBPART = {	:title=>"", 
						:meta_desc=>"", 
						:keyvaluepairs=> {	"0" => { :key => "level",		:value => "" },
											"1" => { :key => "institution",	:value => "" },
											"2" => { :key => "major",		:value => "" },
											"3" => { :key => "marks",		:value => "" },
											"4" => { :key => "more_info",	:value => "" }		}	}		
EDUCATION = 		{ 	:title => "education", 	
						:meta_desc => "stores education data", 
						:subparts =>{	"0" => 	EDUCATION_SUBPART	}	}
				

# experience				
EXPERIENCE_SUBPART = {	:title => "",
						:meta_desc => "",
						:keyvaluepairs => { "0" => { :key => "designation",	:value => "" },
											"1" => { :key => "company",		:value => "" },
											"2" => { :key => "duration",	:value => "" },
											"3" => { :key => "role",		:value => "" },
											"4" => { :key => "more_info",	:value => "" }		}	}
EXPERIENCE = {			:title => "experiences",
						:meta_desc => "stores experiences data",
						:subparts => {	"0" =>  EXPERIENCE_SUBPART	 }		 }				
				


# hobbies				
HOBBIES_SUBPART = {		:title => "",
						:meta_desc => "",
						:keyvaluepairs => { "0" => { :key => "",	:value => "" }	}	}
HOBBIES = 	{			:title => "hobbies",
						:meta_desc => "stores hobbies data",
						:subparts => {	"0" =>  HOBBIES_SUBPART	 }	}
						
				
# achievements				
ACHIEVEMENTS_SUBPART = {:title => "",
						:meta_desc => "",
						:keyvaluepairs => { "0" => { :key => "",	:value => "" }	}	}
ACHIEVEMENTS = 	{		:title => "achievements",
						:meta_desc => "stores achievements data",
						:subparts => {	"0" =>  ACHIEVEMENTS_SUBPART	 }	}
