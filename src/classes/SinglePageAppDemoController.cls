public with sharing class SinglePageAppDemoController {
	
	@RemoteAction
	public static List<Combatant__c> loadCombatants() {
		List<Combatant__c> combatants = [select
			Id,
			Name,
			Description__c,
			Picture__c
			from Combatant__c
			limit 100
		];
		
		return combatants;
		
	}
	
	@RemoteAction
	public static Combatant__c saveCombatant(Combatant__c combatant) {
		upsert combatant;
		return combatant;
	}
	
	@RemoteAction
	public static Battle__c saveBattle(Battle__c battle) {
		insert battle;
		return battle;
	}
	
	@RemoteAction
	public static List<Battle__c> loadBattles() {
		List<Battle__c> battles = [select
			Id,
			Name,
			Winner__c,
			Winner__r.Name,
			Loser__c,
			Loser__r.Name
			from Battle__c
			limit 100
		];
		
		return battles;
	}
	
	@RemoteAction
	public static List<Battle__c> loadCombatantBattles(String combatantSFID) {
		List<Battle__c> battles = [select
			Id,
			Name,
			Winner__c,
			Winner__r.Name,
			Loser__c,
			Loser__r.Name,
			CreatedDate
			from Battle__c
			where Winner__c = :combatantSFID
			or Loser__c = :combatantSFID
		];
		
		return battles;
	}
	
	@RemoteAction
	public static List<sObject> save(List<sObject> records) {
		upsert records;
		return records;
	}

		

}