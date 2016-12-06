@isTest
public class CalloutMock implements HttpCalloutMock {

    public class Request implements HttpCalloutMock {
        protected Integer code;
        protected String status;
        protected String bodyAsString;
        protected Blob bodyAsBlob;
        protected Map<String, String> responseHeaders;

        public Request(Integer code, String status, String body, Map<String, String> responseHeaders) {
            this.code = code;
            this.status = status;
            this.bodyAsString = body;
            this.bodyAsBlob = null;
            this.responseHeaders = responseHeaders;
        }

        public Request(Integer code, String status, Blob body, Map<String, String> responseHeaders) {
            this.code = code;
            this.status = status;
            this.bodyAsString = null;
            this.bodyAsBlob = body;
            this.responseHeaders = responseHeaders;
        }

        public HttpResponse respond(HttpRequest req) {

            HttpResponse res = new HttpResponse();
            res.setStatusCode(this.code);
            res.setStatus(this.status);

            if (this.bodyAsBlob != null) res.setBodyAsBlob(this.bodyAsBlob);
            else res.setBody(this.bodyAsString);

            if (this.responseHeaders != null)
                for (String k : responseHeaders.keyset())
                    res.setHeader(k, responseHeaders.get(k));

            return res;
        }
    }

    public Map<String, HttpCalloutMock> requests;

    public CalloutMock(Map<String, HttpCalloutMock> reqs) {
        this.requests = reqs;
    }

    public HttpResponse respond(HttpRequest req) {
        if (req.getEndPoint().contains('EXCEPTION')) throw new MockException('Mock Exception');

        HttpCalloutMock mock = requests.get(req.getEndPoint());
        if (mock == null) throw new MockException('This mock does not exist');
        return mock.respond(req);
    }

    public class MockException extends Exception {}
}
