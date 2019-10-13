#!/bin/env python3


# This script is made by pdonadeo
# For more info: https://github.com/pdonadeo/rofi-web-search
import json
import re
import urllib.parse
import urllib.request
import sys
import os
import datetime

import subprocess as sp

import html


################################################################################
#####                      C O N F I G U R A T I O N                      ######
################################################################################
SEARCH_ENGINE = 'google'    # or 'duckduckgo'
BROWSER = 'firefox'          # or 'firefox'
################################################################################

CONFIG = {
    'BROWSER_PATH' : {
        'chrome' : '/usr/bin/google-chrome-stable',
        'firefox' : '/usr/bin/firefox'
    },
    'USER_AGENT' : {
        'chrome' : 'Mozilla/5.0 (X11; Fedora; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36',
        'firefox' : 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:69.0) Gecko/20100101 Firefox/69.0'
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
            'accept-encoding' : 'gzip, deflate, br',
            'accept-language' : 'en-US;q=0.9,en;q=0.8',
            'pragma' : 'no-cache',
            'user-agent' : CONFIG['USER_AGENT'][BROWSER],
            'accept' : '*/*',
            'cache-control' : 'no-cache',
            'authority' : 'www.google.com',
            'referer' : 'https://www.google.com/',
            'sec-fetch-site' : 'same-origin'
        }
        req = urllib.request.Request(url, headers={}, method='GET')

        reply_data = urllib.request.urlopen(req).read().split(b'\n')[1]
        reply_data = json.loads(reply_data)
        return [ cleanhtml(res[0]).strip() for res in reply_data[0] ]
    else:   # 'duckduckgo'
        r = {
            'q' : search_string,
            'callback' : 'autocompleteCallback',
            'kl' : 'wt-wt',
            '_' : str(int((datetime.datetime.now().timestamp())*1000))
        }
        url = CONFIG['SUGGESTION_URL'][SEARCH_ENGINE] + urllib.parse.urlencode(r)
        headers = {
            'pragma' : 'no-cache',
            'dnt' : '1',
            'accept-encoding' : 'gzip, deflate, br',
            'accept-language' : 'en-US;q=0.9,en;q=0.8',
            'user-agent' : CONFIG['USER_AGENT'][BROWSER],
            'sec-fetch-mode' : 'no-cors',
            'accept' : '*/*',
            'cache-control' : 'no-cache',
            'authority' : 'duckduckgo.com',
            'referer' : 'https://duckduckgo.com/',
            'sec-fetch-site' : 'same-origin',
        }
        req = urllib.request.Request(url, headers={}, method='GET')
        reply_data = urllib.request.urlopen(req).read().decode('utf8')
        reply_data = json.loads(re.match(r'autocompleteCallback\((.*)\);', reply_data).group(1))
        return [ cleanhtml(res['phrase']).strip() for res in reply_data ]

def main():
    search_string = html.unescape((' '.join(sys.argv[1:])).strip())

    if search_string.endswith('!'):
        search_string = search_string.strip('!').strip()
        results = fetch_suggestions(search_string)
        for r in results:
            print(html.unescape(r))
    elif search_string == '':
        print('Type something and search it with %s' % CONFIG['SEARCH_ENGINE_NAME'][SEARCH_ENGINE])
        print('Close search string with "!" to get suggestions')
    else:
        url = CONFIG['SEARCH_URL'][SEARCH_ENGINE] + urllib.parse.quote_plus(search_string)
        sp.Popen([CONFIG['BROWSER_PATH'][BROWSER], url], stdout=sp.DEVNULL, stderr=sp.DEVNULL, shell=False)

if __name__ == "__main__":
    try:
        main()
    except:
        sys.exit(1)
