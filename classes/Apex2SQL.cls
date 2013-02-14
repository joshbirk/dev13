public with sharing class Apex2SQL {


	public Apex2SQL() {}
		
		
	static public List<String> getObjectNames() {
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
		
		List<String> objNames = new List<String>();
		for(String s : gd.keySet()) {
			if(s.contains('__c') || s.contains('user')) {objNames.add(s);}
		}
		
		objNames.sort();
		return objNames;		
	} 	
	
	
	@RemoteAction
	static public String getObjectSQL(String objectName) {
		Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
		String response = 'CREATE TABLE '+objectName+'(\n';
		String options = '';
		Schema.DescribeFieldResult dr;
		Map<String, Schema.SObjectField> fieldsMap = targetType.getDescribe().fields.getMap();
		for(String s : fieldsMap.keySet()) {
			dr = fieldsMap.get(s).getDescribe();
			response += s + ' ';
			options = '';
			if(!dr.isNillable()) {
				options += ' NOT NULL';
			} 
			options += ',';
			if(String.valueOf(dr.getType()) == 'ID') {
				response +='integer PRIMARY KEY'+options;
			}
			if(String.valueOf(dr.getType()) == 'Reference') {
				String ref = String.valueOf(dr.getReferenceTo()[0]);
				if(ref == 'Group') { ref = 'User'; }
				ref = ref.toLowerCase();
				if(ref == 'user') { ref = 'puser'; }
				response +='integer references '+ref+'(id) '+options;
			}
			if(String.valueOf(dr.getType()) == 'DateTime') {
				response +='timestamp'+options;
			}
			if(String.valueOf(dr.getType()) == 'Date') {
				response +='date'+options;
			}
			if(String.valueOf(dr.getType()) == 'Boolean') {
				response +='boolean'+options;
			}
			if(String.valueOf(dr.getType()) == 'Email' ||
				String.valueOf(dr.getType()) == 'EncryptedString' ||
				String.valueOf(dr.getType()) == 'Phone' ||
				String.valueOf(dr.getType()) == 'MultiPicklist' ||
				String.valueOf(dr.getType()) == 'Picklist' ||
				String.valueOf(dr.getType()) == 'String' ||
				String.valueOf(dr.getType()) == 'URL' 
				) {
				response +='varchar(255)'+options; //todo: check for length
			}
			
			response += '\n';
			
		}	
		
		response = response.substring(0,response.length()-2); //clean up that annoying ,
		response += '\n);';
		
		return response;
		
	}



 


}