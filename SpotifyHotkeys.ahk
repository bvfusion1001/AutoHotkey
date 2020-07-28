; https://gist.github.com/jcsteh/7ccbc6f7b1b7eb85c1c14ac5e0d65195

DetectHiddenWindows, On

; Get the HWND of the Spotify main window.
getSpotifyHwnd() {
	WinGet, spotifyHwnd, ID, ahk_exe spotify.exe
	; We need the app's third top level window, so get next twice.
	spotifyHwnd := DllCall("GetWindow", "uint", spotifyHwnd, "uint", 2)
	spotifyHwnd := DllCall("GetWindow", "uint", spotifyHwnd, "uint", 2)
	Return spotifyHwnd
}

; Send a key to Spotify.
spotifyKey(key) {
	spotifyHwnd := getSpotifyHwnd()
	; Chromium ignores keys when it isn't focused.
	; Focus the document window without bringing the app to the foreground.
	ControlFocus, Chrome_RenderWidgetHostHWND1, ahk_id %spotifyHwnd%
	ControlSend, , %key%, ahk_id %spotifyHwnd%
	Return
}

; Ctrl+Shift+Space: Play/Pause
^+Space::
{
	spotifyKey("{Space}")
	Return
}

; Ctrl+Shift+Right: Next
^+s::
{
	spotifyKey("^{Right}")
	Return
}

; Ctrl+Shift+Left: Previous
^+a::
{
	spotifyKey("^{Left}")
	Return
}

; Ctrl+Shift+Up: Seek forward
^+w::
{
	spotifyKey("+{Right}")
	Return
}

; Ctrl+Shift+Down: Seek backward
^+q::
{
	spotifyKey("+{Left}")
	Return
}

; Shift+volumeUp: Volume up
+Volume_Up::
{
	spotifyKey("^{Up}")
	Return
}

; Shift+volumeDown: Volume down
+Volume_Down::
{
	spotifyKey("^{Down}")
	Return
}

; Ctrl+Shift+CapsLock: Show Spotify
^+CapsLock::
{
	spotifyHwnd := getSpotifyHwnd()
	WinGet, style, Style, ahk_id %spotifyHwnd%
	if (style & 0x10000000) { ; WS_VISIBLE
		WinHide, ahk_id %spotifyHwnd%
	} Else {
		WinShow, ahk_id %spotifyHwnd%
		WinActivate, ahk_id %spotifyHwnd%
	}
	Return
}