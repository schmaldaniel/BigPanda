#!/usr/bin/python
import SimpleHTTPServer
import SocketServer
import os

PORT = {{service_port}}
ADDRESS = "{{service_address}}"

def run(address='', port=80):
    '''
    Get port as variable and run http server based on that port
    '''
    handler = SimpleHTTPServer.SimpleHTTPRequestHandler
    httpd = SocketServer.TCPServer((address, port), handler)
    print "serving at port", PORT
    httpd.serve_forever()

if __name__ == "__main__":
    from sys import argv
    path = os.path.dirname(os.path.realpath(__file__))
    import os
    # Set the root directory to be /resources
    os.chdir(path + '/resources')
    run(address=ADDRESS, port=PORT)