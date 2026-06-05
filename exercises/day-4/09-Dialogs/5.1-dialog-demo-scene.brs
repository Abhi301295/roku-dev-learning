' Day 4 / 09 / Exercise 5 — Dialog demo scene (BrightScript half)
'
' Paired with 5.1-dialog-demo-scene.xml and AppDialog.xml/.brs.
'
' Simulates a failed network call, then shows the reusable AppDialog:
'
'   Network Error
'   Unable to reach the server. Retry?
'   [ Retry ]  [ Cancel ]
'
' Parent observes buttonSelected (child → parent pattern from Day 3).
'
' Expected console:
'   [4.9] DialogDemoScene init
'   [4.9] showing Network Error dialog
'   [4.9] dialog button -> 0 (Retry)
'   [4.9] retrying fetch...

sub init()
    m.statusLabel = m.top.findNode("statusLabel")
    m.errorDialog = m.top.findNode("errorDialog")

    m.errorDialog.observeField("buttonSelected", "onDialogButton")

    print "[4.9] DialogDemoScene init"
    showNetworkError()
end sub

sub showNetworkError()
    print "[4.9] showing Network Error dialog"

    m.errorDialog.title = "Network Error"
    m.errorDialog.message = "Unable to reach the server. Retry?"
    m.errorDialog.visible = true

    m.statusLabel.text = "Waiting for user action..."
end sub

sub onDialogButton(event as object)
    idx = event.getData()
    label = "Cancel"
    if idx = 0 then label = "Retry"

    print "[4.9] dialog button -> " ; idx ; " (" ; label ; ")"

    m.errorDialog.visible = false

    if idx = 0 then
        print "[4.9] retrying fetch..."
        m.statusLabel.text = "Retrying..."
        ' In production you'd re-run the Task here. For the demo we
        ' pretend the retry succeeded.
        m.statusLabel.text = "Connected."
    else
        print "[4.9] user cancelled"
        m.statusLabel.text = "Offline — try again later"
    end if
end sub
