public with sharing class ActionFunctionDemoController {

	public Battle__c battle { get; set; }
	public Combatant__c combatant1 { get; set; }
	public Combatant__c combatant2 { get; set; }

	// ########################################
	// LOAD COMBATANT OPTIONS
	// ########################################
	public List<Combatant__c> combatantOptions {
		get {
			if(combatantOptions == null) {
				combatantOptions = [select
					Id,
					Name,
					Description__c,
					Picture__c
					from Combatant__c
					limit 100
				];
			}
			return combatantOptions;
		}
		set;
	}

	// ########################################
	// CONSTRUCTOR
	// ########################################
	public ActionFunctionDemoController() {
		init();
	}
	
	// ########################################
	// INIT METHOD - HANDLES COMBATANT SELECTION
	// ########################################
	public void init() {
		
		battle = new Battle__c();
		
		Double random;
		Integer randomInt;
		
		Integer combatantOptionCount = combatantOptions.size() - 1;
		
		randomInt = getRandom(combatantOptionCount, null);
		combatant1 = combatantOptions[randomInt];
		
		Set<Integer> excluded = new Set<Integer>();
		excluded.add(randomInt);		
		
		randomInt = getRandom(combatantOptionCount, excluded);
		combatant2 = combatantOptions[randomInt];
		
	}
	
	// ########################################
	// PARAMETER PASSED BY ACTIONFUNCTION TO DECLARE THE WINNER
	// ########################################
	public String winnerSFID { get; set; }
	
	// ########################################
	// SAVE BATTLE
	// ########################################
	public void saveBattle() {
		if(winnerSFID == null) return;
		battle.Winner__c = winnerSFID;
		if(combatant1.Id == winnerSFID) battle.Loser__c = combatant2.Id;
		else battle.Loser__c = combatant1.Id;
		insert battle;
		winnerSFID = null;
		init();
	}
	
	// ########################################
	// RANDOM PICKER CLASS
	// ########################################
	private Integer getRandom(Integer max, Set<Integer> excluded) {
		
		if(excluded == null) excluded = new Set<Integer>();
		
		Double random;
		Integer randomInt;
		
		do {
			random = Math.random() * max;
			if(Math.mod(DateTime.now().millisecond(), 2) == 0) randomInt = Integer.valueOf(Math.ceil(random));
			else randomInt = Integer.valueOf(Math.floor(random));		
		} while(randomInt > max || excluded.contains(randomInt));
		
		return randomInt;
		
	}

}