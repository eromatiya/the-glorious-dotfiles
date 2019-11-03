// ==UserScript==
// @name           userChrome.js
// @namespace      scrollbars_win10
// @version        0.0.4
// @note           Windows 10 style by /u/mrkwatz https://www.reddit.com/r/FirefoxCSS/comments/7fkha6/firefox_57_windows_10_uwp_style_overlay_scrollbars/
// @note           Brought to Firefox 57 by /u/Wiidesire https://www.reddit.com/r/firefox/comments/7f6kc4/floating_scrollbar_finally_possible_in_firefox_57/
// @note           userChrome.js https://github.com/nuchi/firefox-quantum-userchromejs
// @note           Forked from https://github.com/Endor8/userChrome.js/blob/master/floatingscrollbar/FloatingScrollbar.uc.js
// ==/UserScript==

(function () {
	var prefs = Services.prefs,
		enabled;
	if (prefs.prefHasUserValue('userChromeJS.floating_scrollbar.enabled')) {
		enabled = prefs.getBoolPref('userChromeJS.floating_scrollbar.enabled')
	} else {
		prefs.setBoolPref('userChromeJS.floating_scrollbar.enabled', true);
		enabled = true;
	}

	var css = `
		@namespace url(http: //www.mozilla.org/keymaster/gatekeeper/there.is.only.xul);
		:not(select):not(hbox) > scrollbar {
			-moz-appearance: none!important;
			position: relative!important;
			background-color: transparent;
			pointer-events: none;
		}
		:not(select):not(hbox) > scrollbar thumb {
			-moz-appearance: none!important;
			background-color: transparent;
			pointer-events: auto;
		}
		:not(select):not(hbox) > scrollbar[orient = "vertical"] {
			min-width: 12px!important;
			-moz-margin-start: -12px;/*margin to fill the whole render window with content and overlay the scrollbars*/
		}
		:not(select):not(hbox) > scrollbar[orient = "horizontal"] {
			height: 12px!important;
			margin-top: -12px;
		}
		:not(select):not(hbox) > scrollbar[orient = "vertical"] thumb {
			border-right: 2px solid rgba(133, 132, 131, 1);
			width: 12px;
			min-height: 12px;
			transition: border 0.1s ease-in;
		}
		:not(select):not(hbox) > scrollbar[orient = "horizontal"] thumb {
			border-bottom: 2px solid rgba(133, 132, 131, 1);
			min-width: 12px;
			transition: border 0.1s ease-in;
		}
		:not(select):not(hbox) > scrollbar:hover {
			background-color: rgba(0, 0, 0, 0.25);
			max-width: 12px!important;
			point-events: auto;
		}
		:not(select):not(hbox) > scrollbar:hover thumb {
			border-width: 12px;
			transition: border 0s linear;
		}
		:not(select):not(hbox) > scrollbar scrollbarbutton, :not(select):not(hbox) > scrollbar gripper {
			display: none;
		}
	`;

	var sss = Cc['@mozilla.org/content/style-sheet-service;1'].getService(Ci.nsIStyleSheetService);
	var uri = makeURI('data:text/css;charset=UTF=8,' + encodeURIComponent(css));

	var p = document.getElementById('devToolsSeparator');
	var m = document.createElement('menuitem');
	m.setAttribute('label', "Windows 10 Style Scrollbars");
	m.setAttribute('type', 'checkbox');
	m.setAttribute('autocheck', 'false');
	m.setAttribute('checked', enabled);
	p.parentNode.insertBefore(m, p);
	m.addEventListener('command', command, false);

	if (enabled) {
		sss.loadAndRegisterSheet(uri, sss.AGENT_SHEET);
	}

	function command() {
		if (sss.sheetRegistered(uri, sss.AGENT_SHEET)) {
			prefs.setBoolPref('userChromeJS.floating_scrollbar.enabled', false);
			sss.unregisterSheet(uri, sss.AGENT_SHEET);
			m.setAttribute('checked', false);
		} else {
			prefs.setBoolPref('userChromeJS.floating_scrollbar.enabled', true);
			sss.loadAndRegisterSheet(uri, sss.AGENT_SHEET);
			m.setAttribute('checked', true);
		}

		let root = document.documentElement;
		let display = root.style.display;
		root.style.display = 'none';
		window.getComputedStyle(root).display; // Flush
		root.style.display = display;
	}

})();