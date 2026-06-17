#Requires AutoHotkey v2.0
#SingleInstance Force

global Prefix := ""
global Items := ""
global SearchList := []
global CurrentIndex := 1
global PrefixEdit 

; ==========================================
; 1. GUI (User Input Window) Create Karna
; ==========================================
SetupGui := Gui("+AlwaysOnTop", "Image Search Setup")

SetupGui.Add("Text",, "Enter Prefix / Topic (e.g., bike part):")
PrefixEdit := SetupGui.Add("Edit", "w400 vPrefixInput")

SetupGui.Add("Text", "y+15", "Enter comma-separated items:")
ItemsEdit := SetupGui.Add("Edit", "w400 r8 vItemsInput")

CopyPromptBtn := SetupGui.Add("Button", "w150 y+15", "Copy AI Prompt")
CopyPromptBtn.OnEvent("Click", CopyPrompt)

SubmitBtn := SetupGui.Add("Button", "w150 x+20 Default", "Save & Ready")
SubmitBtn.OnEvent("Click", PrepareList)

SetupGui.Show()

; ==========================================
; 2. Progress Tracker GUI (Movable & Compact)
; ==========================================
global ProgressGui := Gui("+AlwaysOnTop -Caption +Border +ToolWindow", "ProgressTracker")
ProgressGui.BackColor := "1E1E1E" 
ProgressGui.SetFont("s14 c00FF00 bold", "Consolas") 
global ProgressText := ProgressGui.Add("Text", "w120 Center", "Wait...")
WinSetTransparent(200, ProgressGui)

OnMessage(0x0201, DragProgressTracker)
DragProgressTracker(wParam, lParam, msg, hwnd) {
    try {
        guiObj := GuiFromHwnd(hwnd)
        if !guiObj
            guiObj := GuiCtrlFromHwnd(hwnd).Gui
        
        if (guiObj.Title == "ProgressTracker")
            PostMessage(0xA1, 2,,, "ahk_id " guiObj.Hwnd)
    }
}

UpdateProgress(DoneCount)
{
    global ProgressText, SearchList
    Remaining := SearchList.Length - DoneCount
    ProgressText.Value := DoneCount " / " SearchList.Length "`nLeft: " Remaining
}

; ==========================================
; 3. AI Prompt Copy Karne ka Function
; ==========================================
CopyPrompt(BtnObj, *)
{
    global PrefixEdit
    
    CurrentTopic := Trim(PrefixEdit.Value)
    
    if (CurrentTopic != "")
    {
        PromptText := "You are a strict data formatting assistant. Follow these rules exactly:`n1. Generate a list of the 50 most important items related to the topic: '" CurrentTopic "'.`n2. The output MUST be ONLY comma-separated values (e.g., item1, item2, item3).`n3. NO introductory text, NO explanations, NO formatting, NO bullet points, and NO quotes. Just the raw comma-separated text."
    }
    else
    {
        PromptText := "You are a strict data formatting assistant. Follow these rules exactly:`n1. You will generate a list of the 50 most important items related to a topic I provide.`n2. The output MUST be ONLY comma-separated values (e.g., item1, item2, item3).`n3. NO introductory text, NO explanations, NO formatting, NO bullet points, and NO quotes. Just the raw comma-separated text.`n4. Right now, do not generate anything. Just reply with exactly: 'What is the topic?'`n5. Wait for my next message containing the topic, then output the strictly formatted comma-separated list."
    }
    
    A_Clipboard := PromptText
    BtnObj.Text := "Copied! ✓"
    SetTimer(() => RestoreBtnText(BtnObj), -2000)
}

RestoreBtnText(BtnObj)
{
    try BtnObj.Text := "Copy AI Prompt"
}

; ==========================================
; 4. Data ko List me Prepare Karna
; ==========================================
PrepareList(*)
{
    global Prefix, Items, SearchList, CurrentIndex, ProgressGui
    
    Saved := SetupGui.Submit() 
    Prefix := Trim(Saved.PrefixInput)
    Items := Saved.ItemsInput

    if (Items = "")
    {
        MsgBox("Item list cannot be empty. Please run the script again.")
        ExitApp
    }

    SearchList := []
    CurrentIndex := 1

    for Part in StrSplit(Items, ",")
    {
        Part := RegExReplace(Part, "[<>:`"\/\\|?*]", "")
        Part := Trim(Part)
        
        if (Part != "")
        {
            QueryString := (Prefix != "") ? (Prefix " " Part) : Part
            SearchList.Push({Query: QueryString, Name: Part})
        }
    }

    X_Pos := A_ScreenWidth - 150
    ProgressGui.Show("NoActivate x" X_Pos " y30")
    UpdateProgress(0) 

    MsgBox("READY!`n`n[Right CTRL] -> Start First Search`n[Right Click] -> Save Image & Next`n[Right Alt] -> Skip to Next`n[Right Shift] -> Pause / Resume")
}

; ==========================================
; 5. Next Search Open Karne ka Function
; ==========================================
OpenNextSearch()
{
    global SearchList, CurrentIndex

    if (CurrentIndex > SearchList.Length)
    {
        MsgBox("All searches completed. Great Job!")
        return
    }

    SearchTerm := SearchList[CurrentIndex].Query

    Url := "https://www.google.com/search?tbm=isch&tbs=isz:lt,islt:4mp&q="
        . StrReplace(SearchTerm, " ", "+")

    if (CurrentIndex == 1)
    {
        Run Url 
    }
    else
    {
        Sleep 100 
        Send "^l" 
        Sleep 50  
        Send "{Text}" Url 
        Sleep 50  
        Send "{Enter}" 
    }

    CurrentIndex++
}

; ==========================================
; 6. Hotkeys (Shortcuts)
; ==========================================

#SuspendExempt
~RShift::
{
    Suspend(-1) 
    if (A_IsSuspended)
    {
        ProgressGui.BackColor := "8B0000" 
        ProgressText.Value := "PAUSED"
    }
    else
    {
        ProgressGui.BackColor := "1E1E1E" 
        UpdateProgress(CurrentIndex - 1)
    }
}
#SuspendExempt False

~RCtrl::
{
    if (SearchList.Length == 0)
        return 

    OpenNextSearch()
}

~RAlt::
{
    if (SearchList.Length == 0)
        return 

    ActiveIndex := CurrentIndex - 1
    if (ActiveIndex > SearchList.Length)
        return

    UpdateProgress(ActiveIndex) 
    OpenNextSearch()
}

~RButton::
{
    global CurrentIndex, SearchList

    if (SearchList.Length == 0)
        return 

    ActiveIndex := CurrentIndex - 1
    
    if (ActiveIndex < 1 || ActiveIndex > SearchList.Length)
        return 

    FileName := SearchList[ActiveIndex].Name

    ; YAHAN CHANGE KIYA HAI: Browser menu ke liye 250ms zaroori hai
    Sleep 250 
    Send "v" 

    if WinWaitActive("Save As", , 3)
    {
        ; Save As window aane ke baad baki sab superfast hi rahega
        Sleep 150 
        Send "^a" 
        Sleep 50  
        Send "{Text}" FileName 
        Sleep 100 
        Send "{Enter}" 

        Sleep 150 
        UpdateProgress(ActiveIndex) 
        OpenNextSearch()
    }
}

Esc::ExitApp