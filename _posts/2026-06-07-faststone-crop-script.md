---
layout: post
title: "AHK Script for Crop Images"
description: "Cropping Multiple Images in FastStone Image Viewer easily with automation tricks."
filename: "FastStoneCropScript.ahk"
categories: [Automation]
subcategories: "FastStone"
---

यहाँ FastStone Image Viewer के लिए AutoHotkey v2 स्क्रिप्ट दी गई है। इसे इस्तेमाल करने के लिए स्क्रिप्ट को `.ahk` फाइल में सेव करें और रन करें।

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
