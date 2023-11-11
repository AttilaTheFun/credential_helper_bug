#!/usr/bin/env python3

import sys
import json
import base64
import os
import netrc
from urllib.parse import urlparse

class Request:
    def __init__(self, uri):
        self.uri = uri

class Response:
    def __init__(self, headers):
        self.headers = headers

def main():

    # Read the command:
    if len(sys.argv) < 2:
        raise ValueError("missing command")
    command = sys.argv[1]
    command = command.strip()
    if command != "get":
        raise ValueError("invalid command: " + command + "\nallowed commands: get")

    # Decode the request:
    request_json = input()
    req = json.loads(request_json, object_hook=lambda d: Request(**d))
    u = urlparse(req.uri)

    # Get the home directory:
    homedir = os.path.expanduser("~")

    # Load the .netrc file:
    try:
        n = netrc.netrc(os.path.join(homedir, "Developer", "Bazel", "credentials", ".netrc"))
    except (FileNotFoundError, netrc.NetrcParseError) as err:
        raise err

    # Find the credentials:
    host = None
    login = None
    password = None
    for host in n.hosts:
        login, _, password = n.authenticators(host)
        if host == u.netloc:
            break
    if login is None or password is None:
        raise ValueError(".netrc missing login or password")

    # Create the response:
    header_value_string = f"{login}:{password}"
    header_value = "Basic " + base64.b64encode(header_value_string.encode()).decode()
    header_values = [header_value]
    res = Response({"Authorization": header_values})

    # Encode the response:
    response_json = json.dumps(res.__dict__)

    # Write to stdout:
    sys.stdout.write(response_json)

if __name__ == "__main__":
    main()