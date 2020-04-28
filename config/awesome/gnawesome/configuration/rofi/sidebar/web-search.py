#!/usr/bin/env python3

# MIT License

# Copyright (c) 2019 Paolo Donadeo

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import json
import re
import urllib.parse
import urllib.request
import sys
import os
import datetime
import gzip

import subprocess as sp

import html


################################################################################
#####                      C O N F I G U R A T I O N                      ######
################################################################################
SEARCH_ENGINE = 'google'            # or 'duckduckgo'
BROWSER = 'firefox'                 # or 'firefox', 'chromium', 'brave', 'lynx'
TERMINAL = ['kitty', '--']          # or ['st', '-e'] or something like that
################################################################################

CONFIG = {
    'BROWSER_PATH' : {
        'chrome' : ['google-chrome-stable'],
        'firefox' : ['firefox'],
        'chromium' : ['chromium-browser'],
        'brave' : ['brave-browser'],
        'lynx' : TERMINAL + ['lynx']
    },
    'USER_AGENT' : {
        'chrome' : 'Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36',
        'firefox' : 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0',
        'chromium' : 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/76.0.3809.100 Chrome/76.0.3809.100 Safari/537.36',
        'brave' : 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36',
        'lynx' : 'Lynx/2.8.9rel.1 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/1.1.1d'
    },
    'SEARCH_ENGINE_NAME' : {
        'google' : 'Google',
        'duckduckgo' : 'DuckDuckGo'
    },
    'SEARCH_URL' : {
        'google' : 'https://www.google.com/search?q=',
        'duckduckgo' : 'https://duckduckgo.com/?q='
    },
    'SUGGESTION_URL' : {
        'google' : 'https://www.google.com/complete/search?',
        'duckduckgo' : 'https://duckduckgo.com/ac/?'
    }
}

def cleanhtml(txt):
    return re.sub(r'<.*?>', '', txt)

def fetch_suggestions(search_string):
    if SEARCH_ENGINE == 'google':
        r = {
            'q' : search_string,
            'cp' : '11',
            'client' : 'psy-ab',
            'xssi' : 't',
            'gs_ri' : 'gws-wiz',
            'hl' : 'en-IT',
            'authuser' : '0'
        }
        url = CONFIG['SUGGESTION_URL'][SEARCH_ENGINE] + urllib.parse.urlencode(r)
        headers = {
            'sec-fetch-mode' : 'cors',
            'dnt' : '1',
            'accept-encoding' : 'gzip',
            'accept-language' : 'en-US;q=0.9,en;q=0.8',
            'pragma' : 'no-cache',
            'user-agent' : CONFIG['USER_AGENT'][BROWSER],
            'accept' : '*/*',
            'cache-control' : 'no-cache',
            'authority' : 'www.google.com',
            'referer' : 'https://www.google.com/',
            'sec-fetch-site' : 'same-origin'
        }
        req = urllib.request.Request(url, headers=headers, method='GET')

        reply_data = gzip.decompress(urllib.request.urlopen(req).read()).split(b'\n')[1]
        reply_data = json.loads(reply_data)
        return [ cleanhtml(res[0]).strip() for res in reply_data[0] ]
    else:   # 'duckduckgo'
        if search_string.startswith('!'):
            bang_search = True
            search_string = search_string.lstrip('!')
        else:
            bang_search = False
        r = {
            'q' : search_string,
            'callback' : 'autocompleteCallback',
            'kl' : 'wt-wt',
            '_' : str(int((datetime.datetime.now().timestamp())*1000))
        }
        url = CONFIG['SUGGESTION_URL'][SEARCH_ENGINE] + urllib.parse.urlencode(r)
        if bang_search:
            url = url.replace('?q=', '?q=!')
        headers = {
            'pragma' : 'no-cache',
            'dnt' : '1',
            'accept-encoding' : 'gzip',
            'accept-language' : 'en-US;q=0.9,en;q=0.8',
            'user-agent' : CONFIG['USER_AGENT'][BROWSER],
            'sec-fetch-mode' : 'no-cors',
            'accept' : '*/*',
            'cache-control' : 'no-cache',
            'authority' : 'duckduckgo.com',
            'referer' : 'https://duckduckgo.com/',
            'sec-fetch-site' : 'same-origin',
        }
        req = urllib.request.Request(url, headers=headers, method='GET')
        reply_data = gzip.decompress(urllib.request.urlopen(req).read()).decode('utf8')
        reply_data = json.loads(re.match(r'autocompleteCallback\((.*)\);', reply_data).group(1))
        return [ cleanhtml(res['phrase']).strip() for res in reply_data ]

def main():
    search_string = html.unescape((' '.join(sys.argv[1:])).strip())

    path_str = os.path.dirname(os.path.realpath(__file__)) + '/'
    icon_path_str = path_str + 'icons/'
    icon_name = icon_path_str

    if SEARCH_ENGINE == 'google':
        icon_name += 'google.svg'
    else:
        icon_name += 'ddg.svg'

    if search_string.startswith('!'):
        search_string = search_string.rstrip('!').strip()
        results = fetch_suggestions(search_string)
        for r in results:
            print(":wb " + html.unescape(r) + "\0icon\x1f"+icon_name+"\n")
    else:
        url = CONFIG['SEARCH_URL'][SEARCH_ENGINE] + urllib.parse.quote_plus(search_string)
        sp.Popen(CONFIG['BROWSER_PATH'][BROWSER] + [url], stdout=sp.DEVNULL, stderr=sp.DEVNULL, shell=False)

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        if e:
            sys.exit(1)
