public with sharing class Apex2SQL_UnitTests {

    public Apex2SQL_UnitTests() {

    }


    @IsTest
    public static void getAllObjectNames() {
        Apex2SQL.getObjectNames();
        Apex2SQL.getObjectSQL('account');
    }
    
    @IsTest
    public static void translateObject2SQL() {
        
    }

}