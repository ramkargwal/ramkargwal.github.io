---
layout: post
title: "Professional & Easy AutoHotkey Script for Cropping Multiple Images in FastStone Image Viewer"
description: "Professional & Easy AutoHotkey Script for Cropping Multiple Images in FastStone Image Viewer easily with automation tricks."
filename: "FastStoneCropScript.ahk"
categories: [Automation]
subcategories: "FastStone"
---

इस स्क्रिप्ट का उपयोग करके आप FastStone Image Viewer में कई इमेजेज को आसानी से क्रॉप कर सकते हैं। यह आपके काम को पूरी तरह ऑटोमेट (Automate) कर देती है। 

नीचे ऑफिशियल कोड एडिटर फॉर्मेट में पूरी स्क्रिप्ट दी गई है:

```autohotkey
; AutoHotkey v2 script
#Requires AutoHotkey v2.0

; Hotkey: Press F2 to run the sequence
F2::
{
    Send("{Enter}")
    Sleep(300)

    Send("^r")
    Sleep(300)

    Send("300")
    Sleep(300)

    Send("{Enter}")
    Sleep(300)

    Send("^s")
    Sleep(300)

    Send("{Enter}")
    Sleep(300)

    Send("{Enter}")
    Sleep(300)

    Send("{Right}")
    Sleep(300)

    Send("x")
}
