' Day 3 / 3.3 — Cross-component communication via m.global
'
' Two responsibilities:
'   1. ensureSharedField() makes sure the global field exists. Real
'      channels declare these centrally in the Scene's init(), but a
'      defensive hasField check is harmless and lets a component be
'      dropped into multiple scenes safely.
'   2. simulateEmit() writes the field. Other components anywhere in
'      the scene will fire their observers (set up with
'      `m.global.observeField("lastEmitter", "onLastEmitter")`).
'
' Expected console output (after two simulateEmit calls):
'   [3.3] init; ensured m.global.lastEmitter exists
'   [3.3] simulateEmit -> m.global.lastEmitter = CrossComponentDemo / hello#1
'   [3.3] simulateEmit -> m.global.lastEmitter = CrossComponentDemo / hello#2

sub init()
    ensureSharedField()
    print "[3.3] init; ensured m.global.lastEmitter exists"
end sub

' Idempotent: hasField + addField is safe to call from many components.
sub ensureSharedField()
    if not m.global.hasField("lastEmitter") then
        m.global.addField("lastEmitter", "string", true)        ' alwaysNotify
    end if
end sub

' Public test trigger: write the shared field. Any other component that
' observed m.global.lastEmitter will have its callback fire.
sub simulateEmit(payload as string)
    m.global.lastEmitter = m.top.subtype() + " / " + payload
    print "[3.3] simulateEmit -> m.global.lastEmitter = " ; m.global.lastEmitter
end sub
