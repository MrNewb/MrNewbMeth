---
uses ox_lib for notify, basically just testing it out.
If you do not wish to use it comment it out, ive left the qb-notify events in but also dont forget to remove 	'@ox_lib/init.lua', from the shared file if you do.
ps-ui is used because its great and the project sloth community is great.

there is a event I was playing with to get qs-phone working with the script similar to how it originally worked  with gc phone, but gonna be honest the support for qs stuff is awful so I dont think im gonna get a way to have the server recive the text without a command.
any ideas are welcomed, any prs are appreciated

heres some videos of it made in the last few weeks
https://www.youtube.com/watch?v=MT3At_eEmYY

https://www.youtube.com/watch?v=gdStxkDCyAg

https://www.youtube.com/watch?v=W7v9o6stHIg

go to 

qb-core\server\ and open player.lua

add a line and paste this in

    PlayerData.metadata['methcooking'] = PlayerData.metadata['methcooking'] or 0


will look like this


    PlayerData.metadata['jobrep']['trucker'] = PlayerData.metadata['jobrep']['trucker'] or 0
    PlayerData.metadata['jobrep']['taxi'] = PlayerData.metadata['jobrep']['taxi'] or 0
    PlayerData.metadata['jobrep']['hotdog'] = PlayerData.metadata['jobrep']['hotdog'] or 0
    PlayerData.metadata['methcooking'] = PlayerData.metadata['methcooking'] or 0 <-------
    PlayerData.metadata['callsign'] = PlayerData.metadata['callsign'] or 'NO CALLSIGN'


and then


add this into qb-core\shared\ and open items.lua

paste this in somewhere

	['meth2'] 					 	 = {['name'] = 'meth2', 						['label'] = 'meth2', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'meth_baggy.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,    ['combinable'] = nil,   ['description'] = 'A baggie of midgrade Meth'},
	['zipdocks'] 					 	 = {['name'] = 'zipdocks', 						['label'] = 'zipdocks', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'meth_baggy.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,    ['combinable'] = nil,   ['description'] = 'A ton of zipdocks'},
	['meth_oz'] 					 	 = {['name'] = 'meth_oz', 						['label'] = 'meth_oz', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'meth_baggy.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,    ['combinable'] = nil,   ['description'] = 'Meth oz'},

	['meth3'] 					 	 = {['name'] = 'meth3', 						['label'] = 'meth3', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'meth_baggy.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,    ['combinable'] = nil,   ['description'] = 'A baggie of fancy meth},
	['sudo'] 			 	    	 = {['name'] = 'sudo', 			  	   			['label'] = 'sudo', 			    	['weight'] = 0, 		['type'] = 'item', 		['image'] = 'sudo.png', 		    	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Sudofed'},
	['antifreeze'] 			 	     = {['name'] = 'antifreeze', 			  	    ['label'] = 'antifreeze', 			    ['weight'] = 0, 		['type'] = 'item', 		['image'] = 'antifreeze.png', 		    ['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Antifreeze'},
	['acetone'] 			 	     = {['name'] = 'acetone', 			  	    	['label'] = 'acetone', 			    	['weight'] = 0, 		['type'] = 'item', 		['image'] = 'acetone.png', 		    	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false,	['combinable'] = nil,   ['description'] = 'Acetone'},
