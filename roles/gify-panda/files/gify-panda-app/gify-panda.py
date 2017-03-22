import SimpleHTTPServer
import SocketServer
import os

PORT = 8000

def run(port=PORT):
    '''
    Get port as variable and run http server based on that port
    '''
    Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
    httpd = SocketServer.TCPServer(("", port), Handler)
    print "serving at port", PORT
    httpd.serve_forever()

if __name__ == "__main__":
    from sys import argv
    import os
    # Set the root directory to be /resources
    os.chdir(os.getcwd() + '/resources')
    run()