CalloutMock
=======================

Simple CalloutMock library. Borrowed from https://developer.salesforce.com/blogs/developer-relations/2013/03/testing-apex-callouts-using-httpcalloutmock.html but with an endpoint router included.

<a href="https://githubsfdeploy.herokuapp.com/?owner=nzchicken&repo=CalloutMock">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

Usage:

    @isTest
    public class RandomTestClass {
        public static CalloutMock.Request authPass = new CalloutMock.Request(200, 'OK', '{\"status\":\"success\"}', new Map<String,String>());        
        public static CalloutMock.Request authFail = new CalloutMock.Request(500, 'ERROR', '', new Map<String,String>());        
        public static CalloutMock.Request randomPass = new CalloutMock.Request(200, 'OK', '{\"status\":\"success\"}', new Map<String,String>());        
        
        public static testMethod void authSuccess() {
            CalloutMock mocks = new CalloutMock(new Map<String, HttpCalloutMock>{
                '/auth' => authPass,
                '/getThing' => randomPass
            });
            
            Test.setMock(HttpCalloutMock.class, mocks);
            
            //do callouts here. endpoing /auth will get the authPass result, endpoint /getThing will get the randomPass result
        }
        
        public static testMethod void authFail() {
            CalloutMock mocks = new CalloutMock(new Map<String, HttpCalloutMock>{
                '/auth' => authFail
            });
            Test.setMock(HttpCalloutMock.class, mocks);
            
            //do callouts here. endpoint /auth will now get authFail (500, with ERROR)
        }
    }
