from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer

PORT = 8001
ADDRESS = '0.0.0.0'

def counted(f):
    def wrapped(*args, **kwargs):
        wrapped.calls += 1
        return f(*args, **kwargs)
    wrapped.calls = 0
    return wrapped


class myHandler(BaseHTTPRequestHandler):
    '''
    Create custom handler that will serve the http requests
    '''

    def _set_headers(self):
        '''
        Set the HTTP headers
        '''
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    @counted
    def do_POST(self):
        '''
        Increase the counter by one in every post
        '''
        self._set_headers()
        self.wfile.write("Thanks for sending POST to the server\n")


    def do_GET(self):
        '''
        Display the POST counter in each GET request
        '''
        self.counter = self.do_POST.calls
        self._set_headers()
        self.wfile.write("<html><body><h1>Total POST request</h1><h4>%s</h4></body></html>" % self.counter)

class http_server:
    '''
    Create http server class
    '''
    def __init__(self, address='', port=80):
        '''
        Initilize post counter and address:port of the service
        '''
        myHandler.counter = 0
        self.port = port
        self.address = address

    def run(self):
        '''
        Run the http server
        '''
        server = HTTPServer((self.address, self.port), myHandler)
        print "serving at port", self.port
        server.serve_forever()

if __name__ == "__main__":
    httpd = http_server(address='',port=PORT)
    httpd.run()