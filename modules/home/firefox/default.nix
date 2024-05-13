{ lib, config, pkgs, inputs, ... }:

{
	config = {
		programs.firefox = {
			enable = true;
			
			profiles = {
		
				main = {
					id = 0;
					name = "main";
					isDefault = true;
				};
			};
		};
	};
}
