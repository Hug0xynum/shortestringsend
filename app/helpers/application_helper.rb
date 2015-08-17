module ApplicationHelper
	#Retourne un titre toujours pertinent
	def titre
		base_titre="SSS"
		if @titre.nil?
			base_titre
		else
			"#{base_titre} | #{@titre}"
		end
	end
	#Affiche le logo
	def logo
		logo = image_tag("logo.png", :alt => "Application Exemple", :class => "round")
	end
end
