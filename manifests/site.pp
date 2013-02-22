class { "devbox":
    hostname 		=> "YOUR_URI", 			# Make sure this maps to the address above
    symfonyVersion	=> "2.1.7", 			# Indicate version of Symfony
    projectName 	=> "PROJECT_NAME", 		# Indicate name of project (without space and special char)
    documentRoot 	=> "PROJECT_NAME/web", 	# Indicate root ex: /PROJECT_NAME/web
    gitUser 		=> "YOUR_USERNAME",
    gitEmail 		=> "YOUR_MAIL"
}
