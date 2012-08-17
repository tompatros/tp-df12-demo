public with sharing class BackboneModelGeneratorController {

	public String types {
		get {
			if(!ApexPages.currentPage().getParameters().containsKey('types')) return '';
			return ApexPages.currentPage().getParameters().get('types');
		}
	}

	public Map<String, Schema.sObjectType> globalDescribe {
		get {
			if(globalDescribe == null) globalDescribe = Schema.getGlobalDescribe();
			return globalDescribe;
		}
		set;
	}
	
	public List<BackboneModel> models {
		get {
			if(models == null) {
				models = new List<BackboneModel>();
				for(String s : globalDescribe.keySet()) {
					Schema.DescribeSObjectResult r = globalDescribe.get(s).getDescribe();
					if(!types.contains(r.getName())) continue;
					BackboneModel m = new BackboneModel();
					m.name = r.getName();
					for(Schema.sObjectField f : r.fields.getMap().values()) {
						m.fields.add(f.getDescribe().getName());
						if(f.getDescribe().getDefaultValueFormula() == null) continue;
						if(f.getDescribe().getType().name() == 'String') m.defaults.put(f.getDescribe().getName(), '\'' + (String)f.getDescribe().getDefaultValueFormula() + '\'');
						else m.defaults.put(f.getDescribe().getName(), (String)f.getDescribe().getDefaultValueFormula());
					}
					//m.fields = r.fields.getMap().keySet();
					models.add(m);
					
					for(Schema.ChildRelationship cr : r.getChildRelationships()) {
						m.children.put(cr.getRelationshipName(), null);
					}
					
				}
			}
			return models;
		}
		set;
	}
	
	public class BackboneModel {
		
		public String name { get; set; }
		public String cleanedName {
			get {
				return name.replace('__c', '');
			}
		}
		public Set<String> fields { get; set; }
		public String fieldsJSON {
			get {
				return JSON.serialize(this.fields);
			}
		}
		public Map<String, String> defaults { get; set; }
		public String defaultsJSON {
			get {
				return JSON.serialize(this.defaults);
			}
		}
		public Map<String, String> children { get; set; }
		
		public BackboneModel() {
			defaults = new Map<String, String>();
			children = new Map<String, String>();
			fields = new Set<String>();
		}
	}

}